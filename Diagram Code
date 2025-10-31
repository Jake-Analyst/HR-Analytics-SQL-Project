
```sql
Table employee_demographics {
  employee_id int [pk]        // Primary key
  first_name varchar
  last_name varchar
  age int
  gender varchar
  birth_date date
}

Table employee_salary {
  employee_id int [pk]        // Primary key
  occupation varchar
  salary decimal
  dept_id int
}

Ref: employee_salary.employee_id > employee_demographics.employee_id
