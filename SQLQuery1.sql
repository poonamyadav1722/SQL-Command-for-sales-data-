SELECT T1.*,T3.*  
FROM Sales AS T1
INNER JOIN Producer AS T2 ON T1.Primary_Producer=T2.Primary_Producer
INNER JOIN Accounts AS T3 ON T2.Office=T3.Primary_Office

/*2 Percentage of deal closed*/

SELECT(COUNT(CASE WHEN Stage_Name='3-Closed Won' THEN 1 END)*100.0)/COUNT(*)AS PercentageClosedWon
From SALES

/* 3*/
UPDATE Sales
SET Niche_Affiliations=COALESCE(Niche_Affiliations,'Others')


/*4*/
/*SELECT*FROM SALES
FULL JOIN Producer ON Sales.Primary_Producer=Producer.Office
WHERE Annual_Revenue>5000
AND Opportunity_Name='Cyber Consultancy'
AND Office='Office2'*/
SELECT S.*
FROM Sales AS S
INNER JOIN Producer AS P ON S.Primary_Producer=P.Primary_Producer
WHERE S.Annual_Revenue>5000
AND S.Opportunity_Name='Cyber Consultancy'
AND P.Office='Office2';


/*5*/
WITH RankedOpportunities AS(
SELECT Opportunity_Name,Stage_Name,Annual_Revenue,ROW_NUMBER() OVER (PARTITION BY Stage_Name ORDER BY Annual_Revenue DESC) AS OpportunityRank
FROM Sales)
SELECT Opportunity_Name, Stage_Name, Annual_Revenue
FROM RankedOpportunities
WHERE OpportunityRank<=5

/*6*/
/*SELECT 
DATEPART(Month FROM Date) AS Month,
COUNT(OpportunityName) AS NumberofOpportunities,
SUM(Annual_Revenue) AS TotalRevenue
FROM Sales
GROUP BY MONTH(Date)
ORDER BY Month*/
SELECT DATEPART(Month,Date) AS Month,COUNT(Opportunity_Name) AS NumberofOpportunities,SUM(Convert(INT,Annual_Revenue)) AS TotalRevenue FROM Sales
WHERE ISNUMERIC(Annual_Revenue)=1
GROUP BY DATEPART(Month,Date),DATENAME(Month,Date)
ORDER BY DATEPART(Month, Date)

/*7*/
SELECT Account_Name, SUM(Convert(INT,Annual_Revenue)) AS TotalRevenue,
CASE
WHEN SUM(Convert(INT,Annual_Revenue))>1000 THEN 'Tier1'
WHEN SUM(Convert(INT,Annual_Revenue)) BETWEEN 5000 AND 10000 THEN 'Tier2'
ELSE 'Tier3'
END AS Tier
FROM SALES
WHERE ISNUMERIC(Annual_Revenue)=1
GROUP BY Account_Name

/*8*/
SELECT Primary_Producer,
SUM(TRY_CONVERT(DECIMAL(18,2),Annual_Revenue)) AS TotalRevenue,
(SUM(TRY_CONVERT(DECIMAL(18,2),Annual_Revenue))/(SELECT SUM(TRY_CONVERT(DECIMAL(18,2),Annual_Revenue))FROM Sales))*100 AS RevenueContributionPercentage
FROM
Sales
WHERE 
/*ISNUMERIC(Annual_Revenue)=1*/
TRY_CONVERT(DECIMAL(18,2),Annual_Revenue) IS NOT NULL
GROUP BY Primary_Producer


/*9*/

ALTER TABLE Sales
ADD COLUMN StageNumber INT;

UPDATE Sales
SET StageNumber =
        CASE
             WHEN Stage_Name='1-Met Client,Data Gather,Insurer Market' THEN 1
             WHEN Stage_Name='2-Client Presentation-Await Feedback' THEN 2
             WHEN Stage_Name='3-Closed Won' THEN 3
             ELSE NULL
        END;


/*10*/

/*SELECT
YEAR(Date) AS Year,
DATEPART(QUARTER,Date) AS Quarter,
SUM(CONVERT(DECIMAL(18,2),Annual_Revenue)) AS QuartelySales
FROM Sales
WHERE TRY_CONVERT(DECIMAL(18,2),Annual_Revenue) IS NOT NULL
GROUP BY
YEAR(Date),
DATEPART(QUARTER,Date)
ORDER BY 
YEAR,
QUARTER;*/

SELECT
YEAR(Date) AS SalesYear,
DATEPART(QUARTER,Date) AS SalesQuarter,
SUM(CONVERT(DECIMAL(18,2),Annual_Revenue)) AS QuartelySales
FROM Sales
WHERE TRY_CONVERT(DECIMAL(18,2),Annual_Revenue) IS NOT NULL
GROUP BY
YEAR(Date),
DATEPART(QUARTER,Date)
ORDER BY 
SalesYear,
SalesQuarter;





















    Account_Name,
    TotalRevenue,
CASE
WHEN TotalRevenue>1000 THEN 'Tier1'
WHEN TotalRevenue BETWEEN 5000 AND 10000 THEN 'Tier2'
ELSE 'Tier3'
END AS Tier
FROM (
   SELECT
       Account_Name,
	   SUM(Annual_Revenue) AS TotalRevenue
   FROM
       Sales
   GROUP BY
       Account_Name
) AS SubqueryAlias;







