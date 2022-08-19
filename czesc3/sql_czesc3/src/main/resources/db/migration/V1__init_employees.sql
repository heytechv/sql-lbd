DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    id serial PRIMARY KEY,
    name varchar(50) NOT NULL,
    surname varchar(50) NOT NULL,
    age int NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    create_on TIMESTAMP NOT NULL
);

ALTER TABLE employees ADD IF NOT EXISTS industry int;
