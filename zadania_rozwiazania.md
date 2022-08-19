## 1.1	 Cel: Wyznaczyć wszystkie płatności, dla kwot większych od wartości 6 dla klienta posiadającego e-mail: ‘dana.hart@sakilacustomer.org’
Format: amount, payment_date

```sql
SELECT p.amount, p.payment_date FROM payment p
INNER JOIN customer c ON p.customer_id=c.customer_id
WHERE c.email='dana.hart@sakilacustomer.org' AND p.amount>6
```

## 1.2. ?
```sql
SELECT DISTINCT l.name AS "language" FROM language l
RIGHT JOIN film f ON l.language_id=f.language_id
```

## 1.3.
```sql
SELECT a.first_name || ' ' || a.last_name AS "actor_name" FROM actor a
LEFT JOIN film_actor fa ON fa.actor_id=a.actor_id
LEFT JOIN film f ON f.film_id=fa.film_id
WHERE f.title='Dozen Lion'
ORDER BY actor_name DESC
```

## 1.4.
```sql
SELECT f.title, f.description FROM film f
LEFT JOIN film_category fc ON fc.film_id=f.film_id
LEFT JOIN category c ON c.category_id=fc.category_id
WHERE c.name='Horror'
LIMIT 5 OFFSET 3
```

## 1.5.
```sql
SELECT f.title, l.name as language FROM film f
LEFT JOIN language l ON f.language_id=l.language_id
LEFT JOIN film_category fc ON fc.film_id=f.film_id
LEFT JOIN category c ON c.category_id=fc.category_id
WHERE l.name!='Japanese' AND c.name='Horror'
```

## 1.6.
```sql
SELECT c.first_name, c.last_name, c.email FROM customer c
LEFT JOIN address a ON c.address_id=a.address_id
LEFT JOIN city ci ON ci.city_id=a.city_id
LEFT JOIN country co ON co.country_id=ci.country_id
WHERE co.country='Algeria'
UNION
SELECT s.first_name, s.last_name, s.email FROM staff s
LEFT JOIN address a ON s.address_id=a.address_id
LEFT JOIN city ci ON ci.city_id=a.city_id
LEFT JOIN country co ON co.country_id=ci.country_id
WHERE co.country='Cameroon'
```

## 1.7.
```sql
SELECT film_id, title,
    CAST( COALESCE(release_year,0) AS varchar(4)),
    CAST( COALESCE(length      ,0) AS varchar(4)),
    CASE WHEN special_features IS NULL
        THEN 'empty'
        ELSE '[' || COALESCE(special_features[1], '') || '][' || COALESCE(special_features[2], '') || ']'
    END AS feature
FROM film
```

## 1.8.
```sql
SELECT rating, COUNT(*) FROM film
GROUP BY rating
HAVING COUNT(*) BETWEEN 200 AND 300
```

## 1.9.
```sql
SELECT
    payment_date,
    EXTRACT(HOUR from payment_date) as hour,
    EXTRACT(MINUTE from payment_date) as minute,
    CAST(EXTRACT(SECOND from payment_date) as int) as second,
    CAST(EXTRACT(MILLISECOND from payment_date) as int)%1000 as miliseconds,
    EXTRACT(DAY from payment_date) as day,
    EXTRACT(MONTH from payment_date) as month,
    EXTRACT(YEAR from payment_date) as year
FROM payment
```

## 1.10.
```sql
SELECT DISTINCT
    s.first_name || ' ' || s.last_name as staff_name,
    md5(s.email),
    ci.city,
    '[' || SUBSTRING(s.email from '(.*)@') || '] - <' || LENGTH(md5(s.email)) || '>'
FROM staff s
LEFT JOIN payment p ON p.staff_id=s.staff_id
LEFT JOIN address a ON a.address_id=s.address_id
LEFT JOIN city ci ON a.city_id=ci.city_id
WHERE s.active=true
    AND p.amount>10
    AND s.email LIKE 'M%@%com'
    AND LENGTH(s.email) > 10
```

## 1.11.
```sql
SELECT
    p.payment_id,
    p.customer_id,
    p.payment_date
FROM payment p
WHERE p.payment_date=(SELECT MAX(payment_date) FROM payment pm WHERE pm.customer_id=p.customer_id) -- maksymalna payment_date dla customer_id

UNION 

SELECT
    p1.payment_id,
    p1.customer_id,
    NULL
FROM payment p1
WHERE p1.payment_date!=(SELECT MAX(payment_date) FROM payment pm WHERE pm.customer_id=p1.customer_id) -- rozna od maksymalna payment_date dla customer_id

ORDER BY customer_id DESC
```

## 1.12.
```sql
SELECT
    LOWER(c.first_name||' '||c.last_name) customer,
    ROUND(SUM(p.amount),2) amount_sum,
    ROUND(AVG(p.amount),2) amount_avg,
    ROUND(COALESCE(VARIANCE(p.amount),0),2) amount_variance
FROM payment p
INNER JOIN customer c ON c.customer_id=p.customer_id
WHERE
    p.payment_date>=DATE('20070215') AND p.payment_date<DATE('20070216')
GROUP BY p.customer_id, c.customer_id
HAVING SUM(p.amount)>5 AND AVG(p.amount)>3 AND COALESCE(VARIANCE(p.amount),0)<5
```

## 1.15.
```sql
WITH RECURSIVE t(xn, r) AS (
    SELECT  -- initial row (init i value, init r value)
        CEIL(EXTRACT(epoch from MAX(re.return_date-re.rental_date))/3600/24),
        (55-CEIL(EXTRACT(epoch from MAX(re.return_date-re.rental_date))/3600/24))/(16-1)
    FROM rental re
    INNER JOIN staff s ON s.staff_id=re.staff_id
    WHERE s.first_name='Mike' AND s.last_name='Hillyer' AND re.return_date IS NOT NULL
        
    UNION ALL
    SELECT  -- next rows
        xn+r,
        r
    FROM t
    WHERE xn < 100
)
SELECT VARIANCE(xn) variance FROM t
```

## 1.13.
```sql
SELECT
    row_number() OVER (),
    f.title, a.first_name||' '||a.last_name actor
FROM inventory i
RIGHT JOIN film f ON f.film_id=i.film_id
LEFT JOIN film_actor fa ON fa.film_id=f.film_id
LEFT JOIN actor a ON a.actor_id=fa.actor_id
WHERE i.film_id is NULL
ORDER BY row_number() OVER ()
OFFSET 49
FETCH FIRST 51 ROW ONLY
```

## 1.14.
```sql
SELECT DISTINCT pg_typeof(film.rating) enum_name, pg_enum.enumlabel enum_value, film.rating FROM film
CROSS JOIN pg_enum WHERE pg_enum.enumlabel=film.rating::text AND film.rating IN ('R','G','PG',NULL)
```


