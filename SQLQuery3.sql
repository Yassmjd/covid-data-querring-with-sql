select*
from [Portfolio covid]..CovidDeaths$
where continent is not null
------------------------------------------ Morocco data----
select location,continent,date,total_cases, total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from [Portfolio covid]..CovidDeaths$
where location like '%morocco%' 
order by deathpercentage desc


------------------------looking at contries with highest  infection rate compared to popultaion	

select location,continent,population,max(total_cases) as highestinfectioncount, max((total_cases/population))*100 as percentagepopulationinfected
from [Portfolio covid]..CovidDeaths$
where continent is not null
group  by location,continent,population
order by  percentagepopulationinfected desc


--------------------------------------------------------------------------
---------------------------------------hignest deathcount per population 
select location, max (cast (total_deaths as int)) as totaldeathscount,max((total_deaths/population))*100 as  percentagetotaldeathsperpopulation
from [Portfolio covid]..CovidDeaths$
where continent is null
group  by location
order by  percentagetotaldeathsperpopulation desc

---------------------  total vaccination vs population ------------------------------------------------------------------------------------------------------------------------

select continent,location, date, population, [new_vaccinations] , SUM(  CONVERT(int, [new_vaccinations])) over ( partition by location order by location) as rollingpeoplevac
from [Portfolio covid]..CovidDeaths$
where  continent is not  null
order by 1,3

------ CTE ****

WITH  POPvsVAC (continent,location, date, population, [new_vaccinations] , rollingpeoplevac)
AS
(
Select continent,location, date, population, [new_vaccinations] , SUM(  CONVERT(int, [new_vaccinations])) over ( partition by location order by location) as rollingpeoplevac
from [Portfolio covid]..CovidDeaths$
where  continent is not  null
--order by 1,3 
)

select* , ( rollingpeoplevac/population)*100 as RollingVacperPeople
from POPvsVAC
order by RollingVacperPeople desc

-------------------------------------------- Creat a View- to store data for visulaization--------------

Create view  CVpercentagetotaldeathsperpopulation as
select location, max (cast (total_deaths as int)) as totaldeathscount,max((total_deaths/population))*100 as  percentagetotaldeathsperpopulation
from [Portfolio covid]..CovidDeaths$
where continent is null
group  by location
---order by  percentagetotaldeathsperpopulation desc
 
  