use music_project;

SELECT location, date , total_cases, new_cases, total_deaths, population FROM coviddeaths
 where continent is not null
 ORDER BY 3, 4;


-- Looking at Total Cases vs Total Deaths
 -- Shows likelihood of dying if your contract covid in your country
SELECT location, date , total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
FROM coviddeaths 
where location like '%India%' 
ORDER BY 1, 2;

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid 
SELECT location, date , population, total_cases, (total_cases/population)*100 as PercentPopulationInfected 
FROM coviddeaths 
where location like '%India%' 
ORDER BY 1, 2;

-- Looking at Countries with Highest Infection Rate Compared to Population

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected 
FROM coviddeaths 
-- where location like '%India%' 
Group by location, population
ORDER BY PercentPopulationInfected desc;

-- Showing Countries with Highest Death Count per Population

-- SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
-- FROM coviddeaths
-- -- WHERE location LIKE '%India%'
-- GROUP BY location
-- ORDER BY TotalDeathCount DESC
-- LIMIT 1000;

SELECT location, MAX(CONVERT(total_deaths, SIGNED)) AS TotalDeathCount
FROM coviddeaths
-- WHERE location LIKE '%India%'
where continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Let's Break things down by Continent 



-- Showing conitntents with the highest death count per population

SELECT location, MAX(CONVERT(total_deaths, SIGNED)) AS TotalDeathCount
FROM coviddeaths
-- WHERE location LIKE '%India%'
where continent is  null
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- GLOBAL NUMBERS 
SELECT date,
       SUM(new_cases) AS total_cases,
       SUM(CONVERT(new_deaths, SIGNED)) AS total_deaths,
       SUM(CONVERT(new_deaths, SIGNED)) / SUM(new_cases) * 100 AS DeathPercentage
FROM coviddeaths
-- WHERE location LIKE '%states%' AND continent IS NOT NULL
 GROUP BY date
ORDER BY 1, 2;

-- Looking at Total Populations vs Vaccinations
WITH PopsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) AS (
    SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
           SUM(CONVERT(vac.new_vaccinations, SIGNED)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
    FROM coviddeaths dea
    JOIN covidvaccinations vac ON dea.location = vac.location AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated/ population )* 100
FROM PopsVac;


-- TEMP Table

CREATE TABLE PercentPopulationVaccinated (
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_Vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

INSERT INTO PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(vac.new_vaccinations, SIGNED)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM coviddeaths dea
JOIN covidvaccinations vac ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

SELECT *, (RollingPeopleVaccinated / population) * 100 AS PercentPopulationVaccinated
FROM PercentPopulationVaccinated;









 


 






 


