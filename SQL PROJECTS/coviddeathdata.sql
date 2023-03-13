-- covid 19 data exploration
--skilles used : joins , Cte ,temp tables window functions , aggerate functions, creating views, converting data types

select * 
from [portfolio project]..CovidDeath

--looking at data where continenet is not null

select * 
from [portfolio project]..CovidDeath
where continent  is not null
order by 1,2 


--select data that i m using in this project

select location, date, total_cases, new_cases , total_deaths, population
from [portfolio project]..CovidDeath

select location, date, total_cases, new_cases , total_deaths, population
from [portfolio project]..CovidDeath
order by 1,2;

--looking at total cases vs total deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from [portfolio project]..CovidDeath
order by 1,2;

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from [portfolio project]..CovidDeath
where location like '%states%'
order by 1,2;

-- looking at total cases vs population

select location, date, total_cases, population , (total_deaths/population)*100 as percentagepopulationinfected
from [portfolio project]..CovidDeath
where location like '%india%'
order by 1,2;

-- look at the countries with the highest infection rate to population

select location, population, MAX(total_cases) AS highestinfectioncount, population , max(total_deaths/population)*100 as percentagepopulationinfected
from [portfolio project]..CovidDeath
group by location , population

select location, population, MAX(total_cases) AS highestinfectioncount, population , max(total_deaths/population)*100 as percentagepopulationinfected
from [portfolio project]..CovidDeath
group by location , population
order by percentagepopulationinfected desc

--countries with highest death count per population

select location, max(cast(total_deaths as int)) as totaldeathcount
from [portfolio project]..CovidDeath
where continent is not null
group by location
order by totaldeathcount desc

--break things down by continent
--continents with highest death counts

select continent, max(cast(total_deaths as int)) as totaldeathcount
from [portfolio project]..CovidDeath
where continent is not null
group by continent
order by totaldeathcount desc 

--global numbers
select date,sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from [portfolio project]..CovidDeath
where continent is not null
group by date
order by 1,2

--joins
--looking at total population vs vaccinations\

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) 
over(partition by  dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from [portfolio project]..CovidDeath  dea
join [portfolio project]..CovidVaccinations  vac
on dea.location = vac.location
and dea.date= vac.date
where dea.continent is not null
order by 2,3

--use cte to perform calculation on partion by on previous query
 
 with popvsvac (continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
 as 
 (select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) 
over(partition by  dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
from [portfolio project]..CovidDeath  dea
join [portfolio project]..CovidVaccinations  vac
on dea.location = vac.location
and dea.date= vac.date
where dea.continent is not null
--order by 2,3
)
select*,(rollingpeoplevaccinated/population)*100
from popvsvac

-- using temp table to perform calculation on partion by in previous query

drop table if exists #percentpopulationvaccinated
Create table #percentpopulationvaccinated
(
continent nvarchar(255),
LOCATION nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)

insert into #percentpopulationvaccinated
 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) 
over(partition by  dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
from [portfolio project]..CovidDeath  dea
join [portfolio project]..CovidVaccinations  vac
on dea.location = vac.location
and dea.date= vac.date
where dea.continent is not null
--order by 2,3

select*,(rollingpeoplevaccinated/population)*100
from #percentpopulationvaccinated


--creating view to store data for later visualization

create view percentpopulationvaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) 
over(partition by  dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
from [portfolio project]..CovidDeath  dea
join [portfolio project]..CovidVaccinations  vac
on dea.location = vac.location
and dea.date= vac.date
where dea.continent is not null
--order by 2,3


select *
from percentpopulationvaccinated







