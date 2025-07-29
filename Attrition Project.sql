CREATE DATABASE Attrition_data;
USE Attrition_data;

ALTER TABLE attrition
RENAME COLUMN `ï»¿Age` TO Age;

-- 1. How many total employees are there?

SELECT count(*)
FROM attrition;

-- 2. How many employees have left the company?

SELECT COUNT(attrition) AS employees_left
FROM attrition
WHERE attrition = 'Yes';

-- 3. What is the attrition rate (percentage)?

-- 4. How many employees are older than 40?

SELECT COUNT(*) AS employees_over_40
FROM attrition
WHERE age > 40;

-- 5. Show the list of employees who have worked for more than 10 years.

SELECT EmployeeNumber AS TotalWorkingYears
FROM attrition
WHERE TotalWorkingYears > 10;

-- 6. Show attrition count by department.

SELECT department, COUNT(*) AS attrition_count
FROM attrition
WHERE attrition = 'Yes'
GROUP BY department;

-- 7. Show attrition count by job role.

SELECT JobRole, COUNT(*) AS attrition_count
FROM attrition
WHERE attrition = 'Yes'
GROUP BY JobRole;

-- 8. Show average monthly income by department.

SELECT Department, avg(MonthlyIncome) AS Avg_MonthlyIncome
FROM attrition
GROUP BY Department;

-- 9. Show average total working years by education field.

SELECT EducationField, avg(TotalWorkingYears) AS Avg_TotalWorkingYears
FROM attrition
GROUP BY EducationField;

-- 10. Show number of employees by marital status.

SELECT MaritalStatus, COUNT(*) AS employee_count
FROM attrition
GROUP BY MaritalStatus;

-- 11. Count how many employees with overtime left the company.

SELECT COUNT(Attrition) AS left_with_overtime
FROM attrition
WHERE OverTime = 'Yes';

-- 12. Find the average income of employees who left vs. who stayed.

SELECT 
attrition,avg(MonthlyIncome) AS avg_income
FROM attrition
GROUP BY attrition;

-- 13. Classify employees into salary bands (low, medium, high) based on MonthlyIncome.

SELECT EmployeeNumber, MonthlyIncome,
    CASE
        WHEN MonthlyIncome < 3000 THEN 'Low'
        WHEN MonthlyIncome BETWEEN 3000 AND 7000 THEN 'Medium'
        ELSE 'High'
    END AS Salary_Bands
FROM attrition;


-- 14. Create a flag for "high risk" employees (low satisfaction + overtime + short tenure).

SELECT EmployeeNumber, JobSatisfaction, OverTime, YearsAtCompany,
    CASE
        WHEN JobSatisfaction <=2 AND OverTime = 'Yes' AND YearsAtCompany <=2 THEN 'High Risk'
        ELSE 'Normal'
    END AS high_risk_flag
FROM attrition;

-- 15. Classify work-life balance as 'Poor', 'Average', 'Good', 'Excellent' using CASE.

SELECT EmployeeNumber, MonthlyIncome,
    CASE
        WHEN MonthlyIncome < 3000 THEN 'Low'
        WHEN MonthlyIncome BETWEEN 3000 AND 7000 THEN 'Medium'
        ELSE 'High'
    END AS Salary_Bands
FROM attrition;

-- 16. Classify work-life balance as 'Poor', 'Average', 'Good', 'Excellent' using CASE.

SELECT 
    WorkLifeBalance,
    CASE 
        WHEN WorkLifeBalance = 1 THEN 'Poor'
        WHEN WorkLifeBalance = 2 THEN 'Average'
        WHEN WorkLifeBalance = 3 THEN 'Good'
        WHEN WorkLifeBalance = 4 THEN 'Excellent'
        ELSE 'Unknown'
    END AS WorkLifeBalanceCategory
FROM attrition;

-- 17.Classify employees into Age Group (Young,Adult,Senior) based on Age.

SELECT  Age,
    CASE
        WHEN Age BETWEEN 18 AND 30 THEN 'Young'
        WHEN Age BETWEEN 31 AND 50 THEN 'Adult'
        ELSE 'Senior'
    END AS AgeCriteria
FROM attrition;

-- 18. Is attrition higher for employees with no stock options?

SELECT StockOptionLevel,COUNT(EmployeeCount) AS total_employees,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(EmployeeCount),2) AS attrition_rate_percent
FROM attrition
GROUP BY StockOptionLevel
ORDER BY StockOptionLevel;


-- 19. -- Is attrition more common in employees with fewer training sessions?-- 

SELECT TrainingTimesLastYear,COUNT(EmployeeCount) AS total_employees,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(EmployeeCount), 2) AS attrition_rate_percent
FROM attrition
GROUP BY TrainingTimesLastYear
ORDER BY attrition_rate_percent;

-- 20. Which job role has the highest attrition rate?

SELECT JobRole,COUNT(EmployeeCount) AS total_employees,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(EmployeeCount), 2) AS attrition_rate_percent
FROM attrition
GROUP BY JobRole
ORDER BY attrition_rate_percent
LIMIT 1;

-- 21. Which age group has the most attrition?

SELECT COUNT(EmployeeCount) AS total_employees,
	CASE 
        WHEN Age BETWEEN 18 AND 30 THEN 'Young'
        WHEN Age BETWEEN 31 AND 50 THEN 'Adult'
        ELSE 'Senior'
    END AS AgeGroup,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(EmployeeCount), 2) AS attrition_rate_percent
FROM attrition
GROUP BY AgeGroup
ORDER BY attrition_rate_percent;

-- 22. Is attrition rate different by gender?

SELECT Gender,COUNT(EmployeeCount) AS total_employees,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(EmployeeCount), 2) AS attrition_rate_percent
FROM attrition
GROUP BY Gender
ORDER BY attrition_rate_percent;

-- 23. Rank employees by monthly income within each department.

SELECT MonthlyIncome, Department, EmployeeNumber,
RANK() OVER (PARTITION BY Department ORDER BY MonthlyIncome DESC) AS IncomeRank
FROM attrition;

-- 24. Rank employees by age within each department.

SELECT Age, Department, EmployeeNumber,
RANK() OVER(PARTITION BY Department ORDER BY Age DESC) AS Age_Rank
FROM attrition;


-- 25. Calculate cumulative attritions by years at company.

SELECT YearsAtCompany, COUNT(EmployeeCount) AS total_employees,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(EmployeeCount), 2) AS attrition_rate_percent
FROM attrition
GROUP BY YearsAtCompany
ORDER BY attrition_rate_percent;

-- 26. Rank employees by DailyRate within each department.

SELECT DailyRate, Department, EmployeeNumber,
RANK() OVER(PARTITION BY Department ORDER BY DailyRate DESC) AS DailyRate_Rank
FROM attrition;

-- 27. Is attrition more common in employees with fewer Salary Hike?

-- SELECT  PercentSalaryHike, COUNT(EmployeeCount) AS total_employees,
-- SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
-- ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(EmployeeCount), 2) AS attrition_rate
-- FROM attrition
-- GROUP BY PercentSalaryHike
-- ORDER BY attrition_rate;


SELECT count(EmployeeCount) as Total_Employee,
case 
when PercentSalaryHike between 11 and 15 then 'Low' 
when PercentSalaryHike between 16 and 21 then 'Average'
else 'High'
end as Hike_Range,
sum(case when Attrition='Yes' then 1 else 0 end) as Attritions,
Round(sum(case when Attrition='yes' then 1 else 0 end)*100/Count(Employeecount),2) as Attrition_Percent
from Attrition
group by Hike_Range
order by attrition_Percent;







