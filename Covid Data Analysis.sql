use Projects

Select * 
From Projects..CovidDeaths_dataset
Where Continent is not Null
Order by 3,4

Select * 
From Projects..CovidVaccinations_dataset
Where Continent is not Null
Order by 3,4

Select Location, date, total_cases, new_cases,total_deaths, population
From Projects..CovidDeaths_dataset
Where Continent is not Null
--Order by 3,4

--Total cases vs Total Deaths
--likelihood of death rate by covid in Nigeria
Select Location, date, total_cases, total_deaths, (total_deaths * 100.0 /total_cases) as DeathPercentage
From Projects..CovidDeaths_dataset
Where Location like '%Nigeria%' and Continent is not Null
Order by Location, date 

/****SELECT
    Location, date, total_cases, total_deaths, (total_deaths * 100.0 / total_cases) AS DeathPercentage
FROM
    Projects..CovidDeaths_dataset
WHERE
    Location LIKE '%States%'
ORDER BY
    Location,
    date;****/

--Total Cases vs Population
--shows %of population that got covid
Select Location, date, population, total_cases, (total_cases * 100.0/population) as PercentagePopulationInfected
From Projects..CovidDeaths_dataset
Where Location like '%nigeria%' and Continent is not Null
Order by Location, date 

--Countries with Highest infection rate compared to population
Select Location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases * 100.0/population)) as PercentPopulationInfected
From Projects..CovidDeaths_dataset
Where Continent is not Null
Group by Location, Population
Order by PercentPopulationInfected desc

--Countries with Highest Death Count per population
Select Location, MAX(cast(total_deaths as int)) AS TotalDeathCount
From Projects..CovidDeaths_dataset
Where Continent is not Null
Group by Location
Order by TotalDeathCount desc

--By Continent

--Cotinent with Highest DeathCount
Select Continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
From Projects..CovidDeaths_dataset
Where Continent is not Null
Group by Continent
Order by TotalDeathCount desc

--Global numbers

Select date,SUM(new_cases) as Total_cases, SUM(new_deaths) as Total_Deaths, SUM(new_deaths)/SUM(new_cases * 100.0) as DeathPercentage
From Projects..CovidDeaths_dataset
Where Continent is not Null
Group by date
Order by 1,2 

--chat GPT
SELECT
    date,
    SUM(new_cases) AS Total_cases,
    SUM(new_deaths) AS Total_Deaths,
    CASE
        WHEN SUM(new_cases) > 0 THEN
            SUM(new_deaths) / NULLIF(SUM(new_cases), 0)
        ELSE
            NULL
    END AS DeathPercentage
FROM
    Projects..CovidDeaths_dataset
WHERE
    Continent IS NOT NULL
GROUP BY
    date
ORDER BY
    date, Total_cases;

SELECT
  --  date,
    SUM(new_cases) AS Total_cases,
    SUM(new_deaths) AS Total_Deaths,
    CAST(SUM(new_deaths) AS FLOAT) / NULLIF(SUM(new_cases), 0)*100 AS DeathPercentage
FROM
    Projects..CovidDeaths_dataset
WHERE
    Continent IS NOT NULL
--GROUP BY
    --date
ORDER BY
     Total_cases;

Select dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations 
From Projects..CovidDeaths_dataset dth
Join Projects..CovidVaccinations_dataset vac
	On dth.location = vac.location
	and dth.date = vac.date
Where dth.continent is not Null
Order by
	dth.continent,dth.location,dth.date;

--analyzing trends in COVID-19 deaths and vaccinations on a per-location basis
-- Total Population vs Vaccinations
Select dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations 
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dth.location Order by 
dth.location,dth.date) as RollingpeopleVaccinated 
From Projects..CovidDeaths_dataset dth
Join Projects..CovidVaccinations_dataset vac
	On dth.location = vac.location
	and dth.date = vac.date
Where dth.continent is not Null
Order by
	dth.continent,dth.location,dth.date;

--Use CTE

with popvsvac (Continent, Location, Date, Population, New_Vaccinations, RollingpeopleVaccinated)
as
(
Select dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations 
, SUM(CONVERT(bigint,Isnull(vac.new_vaccinations,0))) OVER (Partition by dth.location Order by 
dth.location,dth.date) as RollingpeopleVaccinated 
From Projects..CovidDeaths_dataset dth
Join Projects..CovidVaccinations_dataset vac
	On dth.location = vac.location
	and dth.date = vac.date
Where dth.continent is not Null
)
Select * , (RollingpeopleVaccinated * 100.0/Population)
From popvsvac

--SUM(CONVERT(BIGINT, vac.new_vaccinations)) IGNORE NULLS OVER (Partition by dth.location Order by dth.location,dth.date) as RollingpeopleVaccinated


--TEMP TABLE

Drop Table if Exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations 
, SUM(CONVERT(bigint,Isnull(vac.new_vaccinations,0))) OVER (Partition by dth.location Order by 
dth.location,dth.date) as RollingpeopleVaccinated 
From Projects..CovidDeaths_dataset dth
Join Projects..CovidVaccinations_dataset vac
	On dth.location = vac.location
	and dth.date = vac.date
--Where dth.continent is not Null

Select * , (RollingpeopleVaccinated * 100.0/Population)
From #PercentPopulationVaccinated


 
 --CREATING VIEW
 --to Store data for later visualizations

 Create View PercentPopulationVaccinated as
Select dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations 
, SUM(CONVERT(bigint,Isnull(vac.new_vaccinations,0))) OVER (Partition by dth.location Order by 
dth.location,dth.date) as RollingpeopleVaccinated 
From Projects..CovidDeaths_dataset dth
Join Projects..CovidVaccinations_dataset vac
	On dth.location = vac.location
	and dth.date = vac.date
Where dth.continent is not Null
--Order by 2,3

Select * from PercentPopulationVaccinated


