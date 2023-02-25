--select *
--from [Portfolio Project].dbo.CovidDeaths
--where continent is not null
--order by 3,4


--select *
--from [Portfolio Project].dbo.CovidVaccinations
--where continent is not null
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from [Portfolio Project].dbo.CovidDeaths
where continent is not null
order by 1,2

--Total cases vs Total deaths
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from [Portfolio Project].dbo.CovidDeaths
where location='kenya' and continent is not null
order by 1,2


--Total cases vs Population(population who got covid)
select location,date,total_cases,population,(total_cases/population)*100 as PercentagePopInfected
from [Portfolio Project].dbo.CovidDeaths
--where location='kenya'
order by 1,2

--countries with highest infection rates compared to population
select location,MAX(total_cases) as HighestInfectionCount,population,MAX((total_cases/population))*100 as  PercentagePopInfected
from [Portfolio Project].dbo.CovidDeaths
--where location='kenya'
group by location,population
order by PercentagePopInfected desc

--Countries  with highest death count per population
select location,MAX(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project].dbo.CovidDeaths
--where location='kenya'
where continent is not null
group by location
order by TotalDeathCount  desc


--Continents with highest death counts
select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project].dbo.CovidDeaths
--where location='kenya'
where continent is not null
group by continent
order by TotalDeathCount  desc


--Global numbers
select date,SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as DeathPercentage
from [Portfolio Project].dbo.CovidDeaths
--where location='kenya' 
where continent is not null
group by date
order by 1,2

-- Overaall Total cases
select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as DeathPercentage
from [Portfolio Project].dbo.CovidDeaths
--where location='kenya' 
where continent is not null
--group by date
order by 1,2



--Total population that was vaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int))OVER(partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from [Portfolio Project].dbo.CovidDeaths dea
join [Portfolio Project].dbo.CovidVaccinations vac
  on dea.location = vac.location
  and dea.date =vac.date
where dea.continent is not null
order by 2,3

--CTE
WITH Popsvac(continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int))OVER(partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from [Portfolio Project].dbo.CovidDeaths dea
join [Portfolio Project].dbo.CovidVaccinations vac
  on dea.location = vac.location
  and dea.date =vac.date
where dea.continent is not null
--order by 2,3
)
select *,(RollingPeopleVaccinated/population)*100
from Popsvac

--Temp table
drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated
 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int))OVER(partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from [Portfolio Project].dbo.CovidDeaths dea
join [Portfolio Project].dbo.CovidVaccinations vac
  on dea.location = vac.location
  and dea.date =vac.date
--where dea.continent is not null
--order by 2,3
select *,(RollingPeopleVaccinated/population)*100
from  #PercentPopulationVaccinated




--Creating views to store data for later visualization
create view PercentPopulationVaccinated as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int))OVER(partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from [Portfolio Project].dbo.CovidDeaths dea
join [Portfolio Project].dbo.CovidVaccinations vac
  on dea.location = vac.location
  and dea.date =vac.date
where dea.continent is not null
--order by 2,3

create view OverallTotalCases as
select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as DeathPercentage
from [Portfolio Project].dbo.CovidDeaths
--where location='kenya' 
where continent is not null
--group by date
--order by 1,2

create view GlobalNumbers as
select date,SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as DeathPercentage
from [Portfolio Project].dbo.CovidDeaths
--where location='kenya' 
where continent is not null
group by date
--order by 1,2