select*
from dbo.covidDeaths

--select*
--from dbo.covidVacc
--order by 3,4

select Location,date,total_cases,new_cases,total_deaths,population
from PortofolioProject..covidDeaths
order by 1,2


--Total cases vs total Deaths
select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortofolioProject..covidDeaths
where location like 'Guinea'
order by 1,2

--Total cases vs Population
--Percentage of population infected by covid
Select Location,date,population,total_cases,(total_cases/population)*100 as Percentage
from PortofolioProject..covidDeaths
where location like '%states%'
order by 1,2


--Countries with highest infection rate compared to population
Select Location,population,Max(total_cases) as highestinfectcount,Max(total_cases/population)*100 as InfectedPercentage
from PortofolioProject..covidDeaths
Group by location,population
order by InfectedPercentage desc

--countries with the highest deathcount par population
Select Location,population,Max(total_deaths) as deathcount ,Max(total_deaths/population)*100 as DeathPercentage
from PortofolioProject..covidDeaths
Group by location,population
order by DeathPercentage desc
--Deaths count by continent
Select continent,Max(cast(total_deaths as int)) as deathcount 
from PortofolioProject..covidDeaths
where continent is not null
Group by continent
order by deathcount desc



-- Global Numbers 
Select date,Sum(new_cases) as total_cases,Sum(cast(new_deaths as int)) as total_deaths ,Sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortofolioProject..covidDeaths
--where location like '%states%'
where continent is not null
group by date
order by 1,2


select dea.continent ,dea.location, dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location,dea.date) as rollingpeoplevac
from PortofolioProject..covidDeaths dea
Join PortofolioProject..covidVacc vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


--Creating view to store data

create View PercentPopulationvaccinated as 
select dea.continent ,dea.location, dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location,dea.date) as rollingpeoplevac
from PortofolioProject..covidDeaths dea
Join PortofolioProject..covidVacc vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3