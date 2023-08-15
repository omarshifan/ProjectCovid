--	TOTAL CASES VS TOTAL DEATHS
--  Likelihood of you dying in '%country%' during covid

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM coviddeaths
WHERE location like '%india%'
ORDER BY 1,2

-- TOTAL CASES VS POPULATION
-- Depicts percentage of population that got covid
SELECT location, date, total_cases, population, (total_cases/population)*100 as InfectionPercentage
FROM coviddeaths
WHERE location like '%india%'
ORDER BY 1,2

-- Highest Infection rate
SELECT location,  MAX(total_cases) as highest_infection_rate , population, MAX((total_cases/population))*100 as InfectionPercentage
FROM ProjectCovid..coviddeaths
GROUP BY location, population
ORDER BY InfectionPercentage DESC

--Highest death count

SELECT location, MAX(total_deaths) as totaldeathcount
FROM	ProjectCovid..coviddeaths
WHERE continent is not null
GROUP BY location
ORDER BY totaldeathcount DESC

--Highest death count grouping by continent

SELECT continent, MAX(total_deaths) as totaldeathcount
FROM	ProjectCovid..coviddeaths
WHERE continent is not null
GROUP BY continent
ORDER BY totaldeathcount DESC

--GLOBAL NUMBERS
SELECT date, SUM(new_cases), SUM(new_deaths), (SUM(new_deaths)/SUM(new_cases))*100 as DeathPercentage
FROM ProjectCovid..coviddeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

-- TOTAL POPULATION VS VACCINATION
SELECT dea.continent, dea.location, dea.date, dea.population,CAST(vac.new_vaccinations AS bigint), SUM(CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) 
as PeopleVaccinatedCumulative
FROM ProjectCovid..coviddeaths as dea 
JOIN ProjectCovid..covidvaccines as vac
On vac.location = dea.location AND
   vac.date = dea.date
WHERE dea.continent is not null
ORDER BY 2,3
