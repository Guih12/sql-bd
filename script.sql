--UPDATE OF CREATE MY SCRIPT TO LEARNING FOR EXERCISM.

DROP TABLE IF EXISTS users, countries, pais, states, departments, employees, temp_employees;

CREATE TABLE IF NOT EXISTS users(
  id       SERIAL PRIMARY KEY,
  username VARCHAR(255),
  email    VARCHAR(255) UNIQUE
);

CREATE TABLE IF NOT EXISTS countries(
  id          SERIAL PRIMARY KEY,
  country     VARCHAR(255),
  latitude    NUMERIC,
  longitude   NUMERIC,
  name        VARCHAR(255)
);

CREATE TABLE pais(
 id SERIAL PRIMARY KEY,
 name	   varchar(255)
);

CREATE TABLE states(
  id         SERIAL PRIMARY KEY,
  cod        INTEGER      NOT NULL,
  name       VARCHAR      NOT NULL,
  slug       CHAR(2)      NOT NULL,
  country_id INTEGER,
  FOREIGN KEY(country_id) REFERENCES countries (id)
);


CREATE TABLE departments(
  id SERIAL PRIMARY KEY,
  name text NOT NULL
);

INSERT INTO departments (name)
VALUES ('Sales'), ('Marketing'), ('Engineering');


CREATE TABLE employees(
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  department_id INT NOT NULL REFERENCES departments (id),
  hire_date DATE NOT NULL,
  salary INT NOT NULL
);

CREATE TEMPORARY TABLE temp_employees(
  id INT,
  name TEXT,
  department_name TEXT,
  hire_date DATE,
  salary INT
);

COPY employees FROM 'D:\example.csv' DELIMITER ',' CSV HEADER;


-- Para inserir dados fazendo um select para obter algum ID, será necessário criar uma tabela temporária para fazer esse select
-- e depois então excluir essa tabela.
INSERT INTO employees (id, name, department_id, hire_date, salary)
SELECT
  e.id,
  upper(e.name),
  d.id AS department_id,
  e.hire_date,
  e.salary
FROM temp_employees e
JOIN departments d ON e.department_name = d.name;

select * from employees;

COPY countries(country, latitude, longitude, name) 
FROM 'D:\pais.csv' DELIMITER ',' CSV HEADER;

COPY states(cod, name, slug) FROM 'D:\estado.csv' DELIMITER ',' CSV HEADER;

UPDATE states set country_id = (select id from countries where name = 'Brazil');

INSERT INTO users (username, email) values ('[George Lemos]', 'george@gmail.com');
INSERT INTO users (username, email) values ('George Lemos', 'borsato@gmail.com');
INSERT INTO users (username, email) values ('George Lemos', 'lemos@gmail.com');


update users set username = regexp_replace(username,'\[|\]', '', 'g');

CREATE OR REPLACE VIEW show_names_uper AS 
  select upper(username) from users;

SELECT * FROM states join countries on states.country_id = countries.id;


CREATE OR REPLACE VIEW show_salary as  
SELECT em.name, em.salary,
 CASE 
 	WHEN em.department_id = 1 THEN 'super foda'
	WHEN em.department_id = 2 THEN 'esta legal'
	else 'lixo kkkkkkk'
  END type_work
FROM employees as em JOIN departments AS de
ON em.department_id = de.id;

SELECT * FROM show_salary;
