select * from PortfolioProject..covideaths
order by 3,4
where continent is not null

--select * from PortfolioProject..covidvaccination
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..covideaths
order by 1,2

--looking at Total cases vs Total Deaths
-- shows the likelihood of dying if you contract covid in your country

select location,date,total_cases,total_deaths,(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
from PortfolioProject..covideaths
where location like '%india%'
order by 1,2

-- Looking at the total cases vs the population
-- Shows what percentage of population got Covid


select location,date,population,total_cases, (CONVERT(float, total_cases) / NULLIF(CONVERT(float,population ), 0))*100 as PercentagePopulationInfected
from PortfolioProject..covideaths
where location like '%india%'
order by 1,2 

--Looking at Countries with highest Infection Rate compared to Population

select location,population, Max(total_cases)as HighestInfectionCount,max((CONVERT(float, total_cases) / NULLIF(CONVERT(float,population ), 0)))*100 as PercentagePopulationInfected
from PortfolioProject..covideaths
--where location like '%india%'
group by location,population
order by 4 desc

--Showing the countries with Highest Death Count per Population

select location, Max(cast(total_deaths as int))as TotalDeathCount
from PortfolioProject..covideaths
--where location like '%india%'
where continent is not null
group by location
order by TotalDeathCount desc


--Showing the Continents With Highest Death count per population

Select continent, Max(cast(total_deaths as int))as TotalDeathCount
from PortfolioProject..covideaths
--where location like '%india%'
where continent is not null
group by continent
order by TotalDeathCount desc 

 

--Global numbers

set arithabort off
set ansi_warnings off
select SUM(new_cases)as total_cases, sum(new_deaths)as total_deaths, sum(new_deaths)/sum(new_cases)*100 as DeathPercentage  --,(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
from PortfolioProject..covideaths
--where location like '%india%'
where continent is not null
--group by date
order by 1,2

--looking at total population vs vaccinations

with popvsvac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..covideaths dea
join PortfolioProject..covidvaccination as vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null 
--order by 2,3
)
select*,(RollingPeopleVaccinated/population)*100 as percentagepopulationvaccinated
from popvsvac

--create view to store data later

create view percentagepopulationvaccinated as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..covideaths dea
join PortfolioProject..covidvaccination as vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null 
--order by 2,3


select *
from percentagepopulationvaccinated




