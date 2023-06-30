--JOIN two tables
SELECT *
FROM PortfolioProject..CovidVaccinations$ vac
		JOIN PortfolioProject..CovidDeath$ dea ON vac.location = dea.location
			AND vac.DATE = dea.DATE

--Total Population varses Total Vaccination
SELECT dea.continent
		,vac.location
		,dea.population
		,MAX(vac.people_vaccinated) AS people_vaccinated
		,(MAX(vac.people_vaccinated) / dea.population) * 100 AS vaccination_percentage
FROM PortfolioProject..CovidVaccinations$ vac
		JOIN PortfolioProject..CovidDeath$ dea ON vac.location = dea.location
			AND vac.DATE = dea.DATE
WHERE dea.continent IS NOT NULL
GROUP BY vac.location
		,dea.population
		,dea.continent
ORDER BY 2
		,3




--Total Population versus Total Vaccination (another way)
--Creating a CTE (common table expression)
WITH VacVsPop (
	continent
	,location
	,DATE
	,population
	,new_vaccination
	,cumulative_vaccination
	)
AS (
	SELECT dea.continent
		,dea.location
		,dea.DATE
		,dea.population
		,vac.new_vaccinations
		,SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (
			PARTITION BY dea.location ORDER BY dea.location
				,dea.DATE ROWS UNBOUNDED PRECEDING
			) AS cumulative_vaccination
	--(cumulative_vaccination/population)*100
	FROM PortfolioProject..CovidVaccinations$ vac
	JOIN PortfolioProject..CovidDeath$ dea ON vac.location = dea.location
		AND vac.DATE = dea.DATE
	WHERE dea.continent IS NOT NULL
		--ORDER BY 2,3 
		--(The ORDER BY clause is invalid in views, inline functions, derived tables, subqueries, and common table expressions)  
	)
SELECT *
	,(cumulative_vaccination / population) * 100 AS Vaccinated_Population_percentage
FROM VacVsPop
ORDER BY 2
	,3

-------------------------------------------------Creating a Temporary Table
DROP TABLE

IF EXISTS #Percentage_Vaccinated_Population --(Now you can simple edit in the table by rewriting the code)
	CREATE TABLE #Percentage_Vaccinated_Population (
		continent NVARCHAR(255) NULL
		,location NVARCHAR(255) NULL
		,DATE DATETIME NULL
		,population FLOAT NULL
		,new_vaccination FLOAT NULL
		,cumulative_vaccination FLOAT NULL
		)

INSERT INTO #Percentage_Vaccinated_Population
SELECT dea.continent
	,dea.location
	,dea.DATE
	,dea.population
	,vac.new_vaccinations
	,SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (
		PARTITION BY dea.location ORDER BY dea.DATE ROWS UNBOUNDED PRECEDING
		) AS cumulative_vaccination
FROM PortfolioProject..CovidVaccinations$ vac
JOIN PortfolioProject..CovidDeath$ dea ON vac.location = dea.location
	AND vac.DATE = dea.DATE
WHERE dea.continent IS NOT NULL

------------------------------------------------------------------------------------------------------- Temporary Table Created
--Retrive data using Temp table
SELECT *
	,(cumulative_vaccination / population) * 100 AS Vaccinated_Population_percentage
FROM #Percentage_Vaccinated_Population

-- Create a view to store data for later data visualization
DROP VIEW IF EXISTS Percentage_Vaccinated_Population
CREATE VIEW Percentage_Vaccinated_Population
AS
SELECT dea.continent
	,dea.location
	,dea.DATE
	,dea.population
	,vac.new_vaccinations
	,SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (
		PARTITION BY dea.location ORDER BY dea.DATE
			--ROWS UNBOUNDED PRECEDING
		) AS cumulative_vaccination
FROM PortfolioProject..CovidVaccinations$ vac
JOIN PortfolioProject..CovidDeath$ dea ON vac.location = dea.location
	AND vac.DATE = dea.DATE
WHERE dea.continent IS NOT NULL

--Retrive data using veiw
SELECT *
FROM Percentage_Vaccinated_Population