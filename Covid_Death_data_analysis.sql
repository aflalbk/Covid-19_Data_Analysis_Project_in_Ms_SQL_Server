SELECT *
FROM PortfolioProject..CovidDeath$
ORDER BY 1
	,2

--Looking at Total cases vs Total deaths
--It shows likelehood of dying if you contact covid in India
SELECT location
	,DATE
	,total_cases
	,total_deaths
	,(total_deaths * 100 / total_cases) AS death_precentage
FROM PortfolioProject..CovidDeath$
WHERE location LIKE '%India%'
ORDER BY 1
	,2

--Looking at Total cases vs Total Population 
--At what percentage of population affected covid in India
SELECT location
	,DATE
	,population
	,total_cases
	,(total_cases / population) * 100 AS Cases_precentage
FROM PortfolioProject..CovidDeath$
WHERE location LIKE '%India%'
ORDER BY 1
	,2

--Finding the countries with highest infection rate compared to the population.
SELECT location
	,population
	,MAX(total_cases) AS total_cases
	,(MAX(total_cases) / population) * 100 AS infection_rate
FROM PortfolioProject..CovidDeath$
GROUP BY location
	,population
ORDER BY infection_rate DESC

--Finding the countries with highest Death rate compared to the cases.
SELECT location
	,population
	,MAX(total_cases) AS total_cases
	,MAX(total_deaths) AS total_death
	,(MAX(total_deaths) / MAX(total_cases)) * 100 AS death_rate
FROM PortfolioProject..CovidDeath$
--WHERE location like '%India%'
GROUP BY location
	,population
ORDER BY death_rate DESC

--Show the countrys with highest number of death
SELECT location
	,MAX(CAST(total_deaths AS INT)) AS total_death
FROM PortfolioProject..CovidDeath$
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death DESC

--Show the CONTINENT with highest number of death
SELECT location AS continent
	,MAX(CAST(total_deaths AS INT)) AS total_death
FROM PortfolioProject..CovidDeath$
WHERE continent IS NULL
	AND location NOT LIKE '%income%'
GROUP BY location
ORDER BY total_death DESC

--World numbers day by day
SELECT DATE
	,total_cases
	,total_deaths
	,(total_deaths / total_cases) * 100 AS death_percentage
FROM PortfolioProject..CovidDeath$
WHERE location LIKE '%World%'
ORDER BY 1
	,2

--World numbers total look
SELECT location
	,(SUM(new_cases)) AS total_cases
	,(SUM(CAST(new_deaths AS INT))) AS total_deaths
	,((SUM(CAST(new_deaths AS INT))) / (SUM(new_cases))) * 100 AS death_percentage
FROM PortfolioProject..CovidDeath$
WHERE location LIKE '%World%'
GROUP BY location