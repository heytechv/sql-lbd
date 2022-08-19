# CZESC 2
## 1.1. Funkcje - realizuje z czesci 1 zad 1.1
```sql
CREATE OR REPLACE FUNCTION zad1_1(threshold_val int, email_val text)
    RETURNS table(
        amount dec,
        payment_date timestamp
    )
    LANGUAGE plpgsql
AS $$
declare
begin
    return query
        SELECT p.amount, p.payment_date FROM payment p
        INNER JOIN customer c ON p.customer_id=c.customer_id
        WHERE c.email=email_val AND p.amount>threshold_val;
end; $$;

SELECT * FROM zad1_1(6,'dana.hart@sakilacustomer.org')
```

## 1.2. Funkcje - realizuje z czesci 1 zad 1.8
```sql
CREATE OR REPLACE FUNCTION zad1_8(threshold_min bigint, threshold_max bigint)
    RETURNS table(
        rating mpaa_rating,
        count bigint
    )
    LANGUAGE plpgsql
AS $$
declare
begin
    return query
        SELECT f.rating, COUNT(*) FROM film f
        GROUP BY f.rating
        HAVING COUNT(*) BETWEEN threshold_min AND threshold_max;
end $$;

SELECT * FROM zad1_8(200, 300)
```
<br/>

## 2.1. Procedury - dodaje do kazdej platnoscic dla danego customer_id wartosc 1
```sql
CREATE OR REPLACE PROCEDURE dodaj1(customer_id_val int)
    LANGUAGE plpgsql
AS $$
begin
    IF NOT EXISTS (SELECT * FROM payment WHERE customer_id=customer_id_val)
    THEN
        RAISE 'Wprowadzonego customer_id nie znaleziono!';
    END IF;
    
    UPDATE payment SET amount=amount+1 WHERE customer_id=customer_id_val;
    raise notice 'Dodano';
end; $$;

CALL dodaj1(2);

SELECT amount FROM payment WHERE customer_id=2
```

## 2.2 Procedury - usuwa najpierw wpisy w tabeli film_actor, nastepnie aktora z tabeli actor
```sql
CREATE OR REPLACE PROCEDURE usun(actor_id_val bigint)
    LANGUAGE plpgsql
AS $$
begin
    IF (NOT EXISTS (SELECT * FROM film_actor WHERE actor_id=actor_id_val)) AND (NOT EXISTS (SELECT * FROM actor WHERE actor_id=actor_id_val))
    THEN
        RAISE 'actor_id not found!';
    END IF;
        
    DELETE FROM film_actor WHERE actor_id=actor_id_val;
    DELETE FROM actor WHERE actor_id=actor_id_val;
    RAISE NOTICE 'actor_id removed successfully!';

end; $$;

CALL usun(5)
```
<br/>

## 3.1. Wyzwalacze - do tabeli film dodac kolumne wersje (version integer) i po kazdym wykonaniu update na tabeli film powinien zostac uruchomiony wyzwalacz, ktory bedzie inkrementowal wersje
```sql
-- Add column version if not exists
ALTER TABLE film ADD COLUMN IF NOT EXISTS version bigint DEFAULT 1;

--  Create trigger callback function
CREATE OR REPLACE FUNCTION trigger_func()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS $$
begin
    UPDATE film SET version=version+1 WHERE NEW.film_id=film_id;
    RAISE NOTICE 'incremented version';
    RETURN NEW;
end; $$;

--  Create trigger
CREATE OR REPLACE TRIGGER trigger_moj
    AFTER UPDATE
    ON film
    FOR EACH ROW
    WHEN (pg_trigger_depth() < 1)  -- prevent invoking trigger by trigger
    EXECUTE PROCEDURE trigger_func();

--  UPDATE the table to invoke trigger
UPDATE film SET title='siema' WHERE film_id=2;

--  Show results
SELECT title, version FROM film ORDER BY film_id;
```

## 3.2. Wyzwalacze - (WLASNY) po zmianie tytulu filmu, trigger automatycznie zmienia wszystkie znaki na duze
```sql
-- Create function callback for trigger
CREATE OR REPLACE FUNCTION trigger_func_rating()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS $$
begin
    UPDATE film SET title=UPPER(title) WHERE NEW.film_id=film_id AND NEW.title!=OLD.title;
    RETURN NEW;
end; $$;

-- Create trigger
CREATE OR REPLACE TRIGGER trigger_rating
    AFTER UPDATE
    ON film
    FOR EACH ROW
    WHEN (pg_trigger_depth() < 1)
    EXECUTE PROCEDURE trigger_func_rating();

-- Test (call) trigger
UPDATE film SET title='forest gump' WHERE film_id=3;

-- View results
SELECT title, rating FROM film ORDER BY film_id
```

## 4.1. Widoki - zad 1.1 z czesci 1
```sql
CREATE OR REPLACE VIEW widok_zad1_1 AS
    SELECT p.amount, p.payment_date FROM payment p
    INNER JOIN customer c ON p.customer_id=c.customer_id
    WHERE c.email='dana.hart@sakilacustomer.org' AND p.amount>6;

SELECT * from widok_zad1_1
```


## 4.2. Widoki - zad 1.8 z czesci 1
```sql
CREATE OR REPLACE VIEW widok_zad1_8 AS
    SELECT rating, COUNT(*) FROM film
    GROUP BY rating
    HAVING COUNT(*) BETWEEN 200 AND 300;

SELECT * from widok_zad1_8
```