## 1. docker-compose.yml
### Uwaga musi byc USER: postgres (bo potem przy imporcie bazy (restore) sie sapie)
### https://stackoverflow.com/questions/68626017/docker-compose-psql-error-fatal-role-postgres-does-not-exist


```yml
version: "3.8"

services:
    postgresql:
        image: postgres:14.4
        restart: always
        ports:
            - 5432:5432
        environment:
            POSTGRES_PASSWORD: sqlhaslo
            POSTGRES_USER: postgres
            POSTGRES_DB: sqlbaza
    
    pgadmin:
        image: dpage/pgadmin4:latest
        restart: always
        ports:
            - 5050:80
        environment:
            PGADMIN_DEFAULT_EMAIL: admin@admin.com
            PGADMIN_DEFAULT_PASSWORD: sqlhaslo
```


## 2. Import bazy do pgadmin
### https://www.postgresqltutorial.com/postgresql-getting-started/load-postgresql-sample-database/
#### Plik tar mozna po prostu przeciagnac tam w resotre opcji z kompa

## 3. Podstawy SQL
#### https://www.postgresqltutorial.com/postgresql-tutorial/

### SELECT
- Query data from table
```sql
SELECT first_name FROM customer;
```
- Laczenie dwoch kolumn
```sql
SELECT first_name || ' ' || last_name, email FROM curstomer;
```

### Column Alias
#### Pozwala na nazwanie wyniku.
```sql
SELECT first_name || ' ' || last_name AS full_name FROM customer;
```
```sql
SELECT first_name || ' ' || last_name AS "full name" FROM customer;
```

## ORDER BY



