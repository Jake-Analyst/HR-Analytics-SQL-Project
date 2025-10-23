
-- EMPLOYEE SALARY AND DEMOGRAPHICS ANALYSIS

-- 1️ Retrieve all data in the employee salary table
SELECT *
FROM employee_salary;

-- 2️ Retrieve all data in the employee demographics table
SELECT *
FROM employee_demographics;

-- 3️ Join both employee salary and employee demographics tables
SELECT 
    es.employee_id,
    ed.first_name,
    ed.last_name,
    ed.age,
    ed.gender,
    ed.birth_date,
    es.occupation,
    es.salary,
    es.dept_id
FROM employee_salary AS es
JOIN employee_demographics AS ed
ON es.employee_id = ed.employee_id;

-- 4️ Show the average salary per department
SELECT 
    dept_id, 
    ROUND(AVG(salary), 2) AS avg_salary
FROM employee_salary
GROUP BY dept_id
ORDER BY avg_salary DESC;

-- 5️  Show occupations with the highest average salary
SELECT 
    occupation, 
    ROUND(AVG(salary), 2) AS avg_salary
FROM employee_salary
GROUP BY occupation
ORDER BY avg_salary DESC;

-- 6️ Show the top 5 highest-paid employees and their occupations
SELECT 
    ed.first_name, 
    ed.last_name,
    es.occupation,
    ROUND(SUM(es.salary), 2) AS total_salary
FROM employee_salary AS es
JOIN employee_demographics AS ed
ON es.employee_id = ed.employee_id
GROUP BY ed.first_name, ed.last_name, es.occupation
ORDER BY total_salary DESC
LIMIT 5;

-- 7️⃣ Show employees whose total salary is above the company average
SELECT 
    ed.first_name,
    ed.last_name,
    ed.gender,
    SUM(es.salary) AS total_salary
FROM employee_salary AS es
JOIN employee_demographics AS ed
ON es.employee_id = ed.employee_id
GROUP BY ed.first_name, ed.last_name, ed.gender
HAVING SUM(es.salary) > (
    SELECT AVG(total_salary)
    FROM (
        SELECT 
            ed.first_name,
            ed.last_name,
            SUM(es.salary) AS total_salary
        FROM employee_salary AS es
        JOIN employee_demographics AS ed
        ON es.employee_id = ed.employee_id
        GROUP BY ed.first_name, ed.last_name
    ) AS salary_avg
)
ORDER BY total_salary DESC;

-- 8️ Gender pay gap across occupations
SELECT 
    es.occupation,
    ROUND(AVG(CASE WHEN ed.gender = 'Female' THEN es.salary END), 2) AS avg_female_salary,
    ROUND(AVG(CASE WHEN ed.gender = 'Male' THEN es.salary END), 2) AS avg_male_salary,
    ROUND(
        AVG(CASE WHEN ed.gender = 'Male' THEN es.salary END)
        - AVG(CASE WHEN ed.gender = 'Female' THEN es.salary END), 2
    ) AS gender_pay_gap
FROM employee_salary AS es
JOIN employee_demographics AS ed
ON es.employee_id = ed.employee_id
GROUP BY es.occupation
ORDER BY gender_pay_gap DESC;

-- 9️ Gender distribution in the organization
SELECT 
    gender, 
    COUNT(*) AS total_employees,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM employee_demographics), 2) AS percentage
FROM employee_demographics
GROUP BY gender
ORDER BY percentage DESC;

-- 10 Occupations with young (<36) and old (≥36) employees
SELECT 
    es.occupation,
    GROUP_CONCAT(CASE WHEN ed.age < 36 THEN ed.age END ORDER BY ed.age ASC) AS young_employees,
    GROUP_CONCAT(CASE WHEN ed.age >= 36 THEN ed.age END ORDER BY ed.age ASC) AS old_employees
FROM employee_salary AS es
JOIN employee_demographics AS ed
ON es.employee_id = ed.employee_id
GROUP BY es.occupation
ORDER BY es.occupation;
