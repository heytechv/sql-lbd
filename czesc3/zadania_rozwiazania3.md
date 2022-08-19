## pom.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.example</groupId>
    <artifactId>sql_czesc3</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>11</maven.compiler.source>
        <maven.compiler.target>11</maven.compiler.target>
    </properties>

    <dependencies>
        <!-- https://mvnrepository.com/artifact/org.postgresql/postgresql -->
        <dependency>
            <groupId>org.postgresql</groupId>
            <artifactId>postgresql</artifactId>
            <version>42.3.3</version>
        </dependency>

    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.flywaydb</groupId>
                <artifactId>flyway-maven-plugin</artifactId>
                <version>8.5.13</version>
            </plugin>
        </plugins>
    </build>

</project>
```
## flyway.conf
```
flyway.user=postgres
flyway.password=sqlhaslo
flyway.schemas=postgresqlschema
flyway.url=jdbc:postgresql://localhost:5432/postgresqldb
flyway.locations=classpath:db/migration
```

## V1__init_employees.sql

- original
```sql
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
```
`mvn flyway:migrate`
<br/><br/>

- edited
```sql
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    id serial PRIMARY KEY,
    name varchar(50) NOT NULL,
    surname varchar(50) NOT NULL,
    age int NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    create_on TIMESTAMP
);

ALTER TABLE employees ADD IF NOT EXISTS industry int;

```
<br/>

<b>Pyt 10.</b> Po uruchomieniu `mvn flyway:migrate` pokazuje sie ERROR checksum. Mozna pozbyc sie bledu poprzez `mvn flyway:repair`. Niestety usunie to tylko blad, ale nadal nie bedziemy w stanie wykonac skryptu ponownie.
Rozwiazaniem problemu, jest usuniecie bazy employees oraz wpisu w history.

## V2__add_employees.sql
```sql
INSERT INTO employees
    (name, surname, age, email)
VALUES ('Maciek', 'Krol', 12, 'mm@mm.pl');
```

<b>Pyt 12.</b>
<table style='border: solid black 1px;'>
    <tr>
        <td>Version</td>
        <td>Description</td>
        <td>State</td>
    </tr>
    <tr>
        <td>1</td>
        <td>init employees</td>
        <td>Success</td>
    </tr>
    <tr>
        <td>2</td>
        <td>add employees</td>
        <td>Pending</td>
    </tr>
</table>

<b>Pyt 14.</b> Nie udalo sie.
`ERROR: null value in column "create_on" of relation "employees" violates not-null constraint`

## V3__remove_column_employees.sql
```sql
ALTER TABLE employees DROP COLUMN IF EXISTS email;
```

## Wyswietlic wyniki z tabeli employees
```sql
SELECT id, name, surname, email FROM postgresqlschema.employees
```
<b>Pyt 15.</b> Nie udalo sie, poniewaz caly czas krok 2 jest oczekujacy (Pending).
<table style='border: solid black 1px;'>
    <tr>
        <td>id</td>
        <td>name</td>
        <td>surname</td>
        <td>email</td>
    </tr>
</table>

<b>Pyt 16.</b> `mvn flyway:clean`