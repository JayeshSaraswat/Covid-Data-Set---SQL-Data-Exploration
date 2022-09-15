SELECT * FROM portfolio_project.covid_death
order by 3,4;

/*SELECT * FROM portfolio_project.covidvaccinations
order by 3,4*/
--Select data we are using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM portfolio_project.covid_death
order by total_deaths desc;

--looking at total cases vs Total cases

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage
FROM portfolio_project.covid_death
where location like '%India%'
order by 1,2;

--Looking at Total cases vs Population
--shows what percentage of population who got covid 

SELECT location, date, total_cases, population, (total_cases/population)*100 as Death_percentage
FROM portfolio_project.covid_death
where location like '%India%'
order by Death_percentage desc;

--looking at countries who get more infection

SELECT location, MAX(total_cases) as HighestInfection, population, MAX((total_cases/population))*100 as Percentage_infected_population
FROM portfolio_project.covid_death
group by location,population
order by Percentage_infected_population desc;

--showing countries with highest death count per population

--lets break things down by continent

SELECT continent, MAX(total_deaths) as Totaldeath
FROM portfolio_project.covid_death
where continent is not null
group by continent
order by Totaldeath desc;

--SHOWING CONTINENT WITH HIGHTEST DEAT COUNT PER POPULATION

SELECT continent, MAX(total_deaths) as Totaldeath
FROM portfolio_project.covid_death
where continent is  not null 
group by continent
order by Totaldeath desc;

--GLOBAL NUMBERS

SELECT date, sum(new_cases)as total_cases, SUM(CAST(new_deaths AS float))as total_deaths, SUM(CAST(new_deaths AS float))/sum(new_cases)*100 as Deathpercentage
FROM portfolio_project.covid_death
where continent is not null
/*group by date*/

order by Deathpercentage desc;


--Looking Total population vs Vaccinations

	SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	sum(cast(vac.new_vaccinations as float)) 
	OVER(Partition by dea.location order by dea.location,dea.date)as Total_vacc
	FROM portfolio_project.covid_death dea
	join portfolio_project.covidvaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
	where dea.continent is not null
	order by vac.new_vaccinations desc;
    


with PopvsVac (Continent,location,date,populations,Total_vacc,new_vaccinations)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	sum(cast(vac.new_vaccinations as float)) 
	OVER(Partition by dea.location order by dea.location,dea.date)as Total_vacc
	FROM portfolio_project.covid_death dea
	join portfolio_project.covidvaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
	where dea.continent is not null
)
select *, (Total_vacc/populations)*100 as Vaccinations
from PopvsVac

/*TEMP TABLE */
USE portfolio_project;

Create Table PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
Date datetime,
Population int,
new_vaccinations int,
Total_vacc int
)

insert into PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Total_vacc

From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date


Select *, (Total_vacc/Population)*100
From PercentPopulationVaccinated














