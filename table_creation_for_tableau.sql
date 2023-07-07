-- Queries used for Tabluea Project

-- Table 1   (World_Death_Percentage)


SELECT SUM(new_cases) AS Total_cases
	  ,SUM(CAST(new_deaths AS int)) AS Total_death
	  ,(SUM(CAST(new_deaths AS int))/SUM(new_cases))*100 AS DeathPercentAge
FROM PortfolioProject..CovidDeath$
WHERE continent is not null
ORDER BY 1,2


--Table 2 (Continent_Death_Persentage)

SELECT location
	   ,SUM(CAST(new_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeath$
WHERE continent is NULL
	  AND location NOT IN ('World','European Union','International')
GROUP BY location
ORDER BY TotalDeathCount DESC



--Table 3 ( Country_Infection_Rate)

SELECT location
	   ,population
	   ,MAX(total_cases) as HighestInfectionCount
	   ,MAX(total_cases/population)*100 AS InfectionRate
FROM PortfolioProject..CovidDeath$
GROUP BY location
		,population
ORDER BY InfectionRate DESC



--Table 4  ( Daily_Infection_Rate_of_Country)
SELECT location
	   ,population,date
	   ,MAX(total_cases) as InfectionCount
	   ,MAX(total_cases/population)*100 AS InfectionRate
FROM PortfolioProject..CovidDeath$
GROUP BY location
		,population
		,date
ORDER BY InfectionRate DESC

--OR

SELECT location
	   ,population
	   ,date
	   ,total_cases as InfectionCount
	   ,total_cases/population*100 AS InfectionRate
FROM PortfolioProject..CovidDeath$
ORDER BY InfectionRate DESC