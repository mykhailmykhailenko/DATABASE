SELECT * FROM users;


SELECT first_name AS "Ім'я", 
    last_name AS "Прізвище"
FROM users;


-------Умовні конструкції-------


/* -----1 variant------
CASE
    WHEN condition1 = value
        THEN result1
    WHEN condition2 = value
        THEN result2
    ELSE 
        result3
END
*/


SELECT *, (
    CASE
        WHEN is_subscribe = TRUE
            THEN 'Підписаний'
        WHEN is_subscribe = FALSE
            THEN 'Не підписаний'
        ELSE 'Невідомо'
    END
)
FROM users;



ALTER TABLE orders
ADD COLUMN status boolean;

UPDATE orders
SET status = true
WHERE id % 3 = 0;

UPDATE orders
SET status = false
WHERE id % 2 = 0;


/*
1. Оновити замовлення, кожному третьому дайте статус true, у всіх інших - статус false
2. Виведіть інфо про замовлення, де якщо статус true - вивести "done", статус false - вивести "processing", null - вивести "new"
*/


SELECT *,
        (CASE
        WHEN status = TRUE
            THEN "done"
        WHEN status = FALSE
            THEN "processing"
        ELSE "new"
            )
FROM orders;


/* ------- 2 variant ------ */


/*
CASE  conditioanl_Value
    WHEN value1
        THEN result1
    WHEN value2
        THEN result2
    ELSE default_value
END
*/

SELECT *, (
    CASE (extract("month" from birthday))
        WHEN 1 THEN 'winter'
        WHEN 2 THEN 'winter'
        WHEN 3 THEN 'spring'
        WHEN 4 THEN 'spring'
        WHEN 5 THEN 'spring'
        WHEN 6 THEN 'summer'
        WHEN 7 THEN 'summer'
        WHEN 8 THEN 'summer'
        WHEN 9 THEN 'fall'
        WHEN 10 THEN 'fall'
        WHEN 11 THEN 'fall'
        WHEN 12 THEN 'winter'
    ELSE 'unknown'
END
) AS "birth season"
FROM users;


/*
Витягти всю інформацію про юзерів, створити нову колонку - повнолітність.
Якщо користувачу менше ніж 18 повних років - виводити "неповнолітній",
якщо більше - вивести "повнолітній"
*/


SELECT *,  (
    CASE
        WHEN  extract('years' from age(birthday)) > 18
        THEN 'повнолітній'
        ELSE
        'неповнолітній'
    END
) AS "Повнолітність"
FROM users;


/*
1. Вивести всі телефони, в стопці "manufacturer" вивести виробника - якщо бренд - iPhone, то вивести Apple, для всіх інших - вивести "Other"
2. Вивести всі телефони, в стопці "price_category" вивести
якщо ціна > 10 000 - flagman
ціна < 1000 - cheap
1000 > ціна < 10 000 - middle
3. Вивести всіх користувачів та їхній статус - якщо у користувача > 3 замовлення, то він постійний клієнт,
якщо від 1 до 3 - то він активний клієнт
якщо 0 - то він новий клієнт
*/

---1

SELECT *, (
    CASE brand
        WHEN 'iPhone' THEN 'Apple'
        ELSE 'Other'
    END
) AS manufacturer
FROM products;

---2
SELECT *, (
    CASE
        WHEN price < 1000 THEN 'Cheap'
        WHEN price > 10000 THEN 'Flagman'
        WHEN price BETWEEN 1000 AND 10000 THEN 'Middle'
        ELSE 'Other'
    END
) AS price_category
FROM products;

---3
SELECT u.id, u.email, (
    CASE 
    WHEN count(o.id) > 3 
    THEN 'regular client'
    WHEN count(o.id) BETWEEN 1 AND 3
    THEN 'active client'
    WHEN count(o.id) = 0
    THEN 'new client'
    ELSE 'Unknown'
    END
) AS client_status
FROM users AS u
LEFT JOIN orders AS o
ON u.id = o.customer_id
GROUP BY u.id, u.email;


--------COALESCE----------

SELECT id, brand, model, price, COALESCE(category, 'smartphone') AS category
FROM products;


-------GREATEST, LEAST-----

SELECT *, LEAST(price, 500) AS sale_price
FROM products;

SELECT *, GREATEST(price, 500) AS new_price
FROM products;

-----------Підзапити (подзапросы) -----------

/*   IN, NOT IN, SOME/ANY, EXISTS */

SELECT *
FROM users AS u
WHERE u.id NOT IN (
        SELECT o.customer_id
        FROM orders AS o
);

/*
Знайти телефони, які ніколи не купували
*/


SELECT *
FROM products AS p
WHERE p.id NOT IN (
    SELECT product_id
    FROM orders_to_products
);

SELECT * 
FROM products AS p
WHERE p.id NOT IN (
    SELECT product_id
    FROM orders_to_products
);

-----------------EXISTS---------------

SELECT *
FROM users
WHERE id = 290;

SELECT EXISTS
    (SELECT *
    FROM users
    WHERE id = 293);

---- Чи робив юзер 293 хоч одне замовлення?

SELECT EXISTS
    (SELECT o.customer_id
    FROM orders AS o
    WHERE id = 293);

SELECT u.id, u.email, (EXISTS
                    (SELECT o.customer_id
                    FROM orders AS o))
FROM users AS u;

----ANY/SOME----

---(IN)---

--Якщо хоч для якогось значення умова = true -  то повернеться true

--------------ALL--------

--Якщо для всіх рядків значення = true

SELECT *
FROM products AS p
WHERE p.id != ALL (
            SELECT product_id 
            FROM orders_to_products
);
