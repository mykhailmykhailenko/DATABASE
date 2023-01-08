--SELECT щось FROM звідкись

SELECT id, first_name, last_name FROM users;

---- Результатом роботи команди SELECT ЗАВЖДИ є таблиця

SELECT first_name, last_name FROM users;

SELECT * FROM users
WHERE id = 2000;

SELECT * FROM users
WHERE gender = 'male';

SELECT * FROM users
WHERE gender = 'male' AND is_subscribe;

/*
1. Отримати всіх юзерів, в яких id парний
2. Отримати всіх юзерів жіночого роду, які не підписані на наші новини.
*/

SELECT * FROM users
WHERE id % 2 = 0;

SELECT * FROM users
WHERE gender = 'female' AND is_subscribe = false;


---- масив мейлів всіх підписаних юзерів

SELECT email FROM users
WHERE is_subscribe;

-----------------

SELECT * FROM users
WHERE first_name = 'William';

SELECT * FROM users
WHERE first_name IN ('John', 'William', 'Clark');


/* 
Знайти всіх користувачів, в яких id 1, 10, 100, 1000
*/

SELECT * FROM users
WHERE id IN (1, 10, 100, 1000);


--- Знайти всіх, в кого id між 1800 і 2000

SELECT * FROM users
WHERE id > 1800 AND id < 2000;


SELECT * FROM users
WHERE id BETWEEN 1800 AND 2000;



--------------


SELECT * FROM users
WHERE first_name LIKE 'K%';


--- % - будь-яка кількість будь-яких літер
--- _ - 1 будь-який символ


---- ім'я з 5 літер


SELECT * FROM users
WHERE first_name LIKE '_____';


-- знайти користувачів, ім'я яких закінчується на літеру "а"
SELECT * FROM users
WHERE first_name LIKE '%a';


UPDATE users
SET weight = 60
WHERE id BETWEEN 900 AND 950;


-----встановити вагу 70 кг для всіх, в кого id ділиться на 5

UPDATE users
SET weight = 70
WHERE id % 5 = 0;

DELETE FROM users
WHERE id = 1
RETURNING *;


---------------------


SELECT * FROM users
WHERE birthday < '2004-01-01';


SELECT first_name, extract("years" from age(birthday)) FROM users;

SELECT * FROM users
WHERE extract("years" from age(birthday)) > 25;


/*
Вивести мейли всіх юзерів чоловічого роду, яким більше 18 і менше 60 років.
*/


SELECT email FROM users
WHERE gender = 'male' AND
(extract("years" from age(birthday)) BETWEEN 18 AND 60);


/*
1. Отримати всіх користувачів, які народились у жовтні
2. Отримати мейли всіх користувачів, які народились 1 листопада
3. Всім користувачам, яким більше ніж 60 років, встановити зріст 2 метри.
4. Всім користувачам чоловічого роду віком від 30 до 50 встановити вагу 80кг.
*/


----1
SELECT * FROM users
WHERE extract('month' from birthday) = 10;


---2
SELECT email FROM users
WHERE extract('day' from birthday) = 1 AND extract('month' from birthday) = 11;

---3
UPDATE users
SET height = 2.0
WHERE extract('years' from age(birthday)) > 60;

---4
UPDATE users
SET weight = 80
WHERE (extract('years' from age(birthday)) BETWEEN 30 AND 50) 
AND gender = 'male';


------------aliases


SELECT * FROM users;


SELECT id AS "Порядковий номер",
first_name AS "Ім'я",
last_name AS "Прізвище",
email AS "Пошта",
is_subscribe AS "Підписка"
FROM users AS u;


SELECT * FROM users AS u
WHERE u.id = 900;

-------------------Пагінація---------------

SELECT * 
FROM users
LIMIT 10;


SELECT * FROM users
LIMIT 10
OFFSET 20;

/*
Третя сторінка всіх замовлень, де кількість елементів на видачу 50.
*/


SELECT * FROM users
LIMIT 50
OFFSET 100;


------------------------functions

SELECT id, first_name || ' ' ||last_name AS full_name 
FROM users;


SELECT id, concat(first_name, ' ', last_name) AS full_name
FROM users;


---1
SELECT id, concat(first_name, ' ', last_name) AS full_name
FROM users
WHERE char_length(concat(first_name, ' ', last_name)) > 10;


--2
SELECT * FROM (
    SELECT id, concat(first_name, ' ', last_name) AS full_name
    FROM users
    ) AS fn
WHERE char_length(fn.full_name) > 10;


UPDATE users
SET height = 3.0, weight = 90
WHERE id = 2000;


SELECT * FROM users
WHERE id = 2000;


---------Агрегатні функції--------

SELECT max(height)
 FROM users;


SELECT avg(height)
 FROM users;


SELECT count(*)
FROM users
WHERE gender = 'female';

---- Середня вага чоловіків

SELECT avg(weight)
FROM users
WHERE gender = 'male';

---------

SELECT avg(weight), gender
FROM users
GROUP BY gender;



--------

SELECT avg(weight)
FROM users
WHERE birthday > '2000-01-01';


-----Середня вага чоловіків старше 25 років. 

SELECT avg(weight), gender
FROM users
WHERE extract('year' from age(birthday)) > 25
GROUP BY gender;



--1. Середня зріст всіх користувачів

SELECT avg(height)
FROM users;

--2. Найбільший, найменший зріст чоловіків і жінок.

SELECT max(height), min(height), gender
FROM users
GROUP BY gender;

--3. Кількість юзерів, які народились після 1999 року.
SELECT count(*)
FROM users
WHERE birthday > '1999-12-31';

--4. Кількість людей з ім'ям Katie
SELECT count(*)
FROM users
WHERE first_name ILIKE 'Katie';

--5. Кількість людей віком від 20 до 30 років.
SELECT count(*)
FROM users
WHERE extract('years' from age(birthday)) BETWEEN 20 AND 30;

--6. Кількість користувачів висотою більше 1.5метри.
SELECT count(*)
FROM users
WHERE height > 1.5


--1. Кількість замовлень кожного юзера

SELECT count(*), customer_id
FROM orders
GROUP BY customer_id;


----Середня ціна телефону по кожному бренду

SELECT avg(price), brand
FROM products
GROUP BY brand;


---Кількість телефонів на складі (в наявності)
SELECT sum(quantity)
FROM products;

--Кількість проданих телефонів всього магазину
SELECT sum(quantity)
FROM orders_to_products;


-------------------------

/*
Створити нову таблицю workers:
- id,
- name,
- salary,
- birthday
1. Додайти робітника з ім'ям Олег, 90р.н., зп 300
2. Додайте робітницю Ярославу, зп 1200
3. Додайте двох нових робітників одним запитом - Сашу 85р.н., зп 1000, і Машу 95р.н., зп 900
4. Встановити Олегу зп у 500.
5. Робітнику з id = 4 встановити рік народження 87
6. Всім, в кого зп > 500, врізати до 700.
7. Робітникам з 2 по 5 встановити рік народження 99
8. Змінити Сашу на Женю і збільшити зп до 900.
9. Вибрати всіх робітників, чия зп > 400.
10. Вибрати робітника з id = 4
11. Дізнатися зп та вік Жені.
12. Знайти робітника з ім'ям Петя.
13. Вибрати робітників у віці 27 років або з зп > 800
14. Вибрати робітників у віці від 25 до 28 років (вкл)
15. Вибрати всіх робітників, що народились у вересні
16. Видалити робітника з id = 4
17. Видалити Олега
18. Видалити всіх робітників старше 30 років.
*/

CREATE TABLE workers(
    id serial PRIMARY KEY,
    name varchar(250) NOT NULL CHECK (name != ''),
    salary int NOT NULL CHECK (salary > 0),
    birthday date
)

-- 1 Додайти робітника з ім'ям Олег, 90р.н., зп 300
INSERT INTO workers (name, salary, birthday) VALUES
('Олег', 300, '1990-01-25');

-- 2 Додайте робітницю Ярославу, зп 1200
INSERT INTO workers (name, salary, birthday) VALUES
('Ярослава', 1200, NULL);

-- 3 Додайте двох нових робітників одним запитом - Сашу 85р.н., зп 1000, і Машу 95р.н., зп 900
INSERT INTO workers (name, salary, birthday) VALUES
('Саша', 1000, '1985-05-10'),
('Маша', 900, '1995-08-21');

-- 4 Встановити Олегу зп у 500.
UPDATE workers
SET salary = 500
WHERE id =1;

-- 5 Робітнику з id = 4 встановити рік народження 87
UPDATE workers
SET birthday = '1987-08-21'
WHERE id = 4;

--6 Всім, в кого зп > 500, врізати до 700.
UPDATE workers
SET salary = 700
WHERE salary > 500;

--7 Робітникам з 2 по 5 встановити рік народження 99
UPDATE workers
SET birthday = '1999-01-01'
WHERE id BETWEEN 2 AND 5;

--8 Змінити Сашу на Женю і збільшити зп до 900.
UPDATE workers
SET name= 'Женя', salary = 900
WHERE id = 3;

--9 Вибрати всіх робітників, чия зп > 400.
SELECT * FROM workers
WHERE salary > 400;

--10 Вибрати робітника з id = 4 
SELECT * FROM workers
WHERE id = 4;

--11 Дізнатися зп та вік Жені.
SELECT salary, (extract('years' from age(birthday))) FROM workers
WHERE name = 'Женя';

--12 Знайти робітника з ім'ям Петя.
SELECT * FROM workers
WHERE name = 'Петя';

--13 Вибрати робітників у віці 27 років або з зп > 800
SELECT * FROM workers
WHERE (extract('years' from age(birthday)) = 27) OR salary > 800;

--14 Вибрати робітників у віці від 25 до 28 років (вкл)
SELECT * FROM workers
WHERE (extract('years' from age(birthday)) BETWEEN 25 AND 28);

--15. Вибрати всіх робітників, що народились у вересні
SELECT * FROM workers
WHERE extract('month' from birthday) = 9;

-- 16. Видалити робітника з id = 4
DELETE from workers
WHERE id = 4;

-- 17. Видалити Олега
DELETE from workers
where name = 'Олег';

-- 18. Видалити всіх робітників старше 30 років.
DELETE from workers
WHERE extract('years' from age(birthday)) > 20;



--//////////////////Сортування, фільтрація/////////////////////////////

---Дізнатись, якого бренду телефонів залишилось меньше всього на складі
SELECT min(quantity), brand
FROM products
GROUP BY brand;

/*
Відсортувати юзерів за айді
ORDER BY (за яким полем сортуємо) (принцип сортування: за більшенням ASC / за зменшенням DESC)
*/

SELECT * FROM users
ORDER BY id ASC;

SELECT * FROM users
ORDER BY first_name ASC;

------

SELECT * FROM users
ORDER BY height, birthday;

---------------------

SELECT *
FROM products
ORDER BY quantity;

---------------

/*
Топ-5 найдорожчих телефонів
*/

SELECT *
FROM products
ORDER BY price DESC
LIMIT 5;

/*
1. Відсортуйте користувачів за кількістю повних років (не дата народження, а кількість років), і для тих, хто має однаковий вік - за алфавітом у зворотньому порядку
2. Відсортуйте по ціні від меншого до більшого
*/

---2
SELECT *
FROM products
ORDER BY price ASC;

---1
SELECT *, extract('years' from age(birthday)) FROM users
ORDER BY extract('years' from age(birthday)), first_name DESC;

--------
/* Кількість однорічок */

SELECT extract('years' from age(birthday)), count(*) 
FROM users
GROUP BY extract('years' from age(birthday))
ORDER BY extract('years' from age(birthday));


SELECT count(*), age 
FROM (
    SELECT *,  
    extract('years' from age(birthday)) AS age
    FROM users) AS u_w_age
GROUP BY age
ORDER BY age;

--------------

--HAVING

---WHERE працює на рівні кортежу (рядка в таблиці), HAVING фільтрує на рівні групи

SELECT count(*), age 
FROM (
    SELECT *,  
    extract('years' from age(birthday)) AS age
    FROM users) AS u_w_age
GROUP BY age
HAVING count(*) >= 5
ORDER BY age;

/*
Витягти id користувачів, які робили щонайменше 3 замовлення.
*/

SELECT count(*), customer_id
FROM orders
GROUP BY customer_id
HAVING count(*) >= 3;

/*
Витягти всі бренди, в яких сума кількості телефонів на складі більше ніж 50 000
*/

SELECT sum(quantity), brand
FROM products
GROUP BY brand
HAVING sum(quantity) > 50000;

-------////////////////--------

CREATE TABLE a
(v char(3),
t int);

CREATE TABLE b 
(v char(3));

INSERT INTO a VALUES
('XXX', 1), ('XXY', 1), ('XXZ', 1),
('XYX', 2), ('XYY', 2), ('XYZ', 2),
('YXX', 3), ('YXY', 3), ('YXZ', 3);

INSERT INTO b VALUES
('ZXX'), ('XXX'), ('ZXZ'), ('YXZ'), ('YXY');

--
SELECT * FROM A, B;

-----Об'єднання (обьединение) - UNION -----

SELECT v FROM a UNION 
SELECT * FROM a;

-----Перехрещення(пересечение) - INTERSECT ---

SELECT v FROM a
INTERSECT
SELECT * FROM b;

-----Віднімання (мінус) - EXCEPT ---

SELECT v FROM a
EXCEPT
SELECT * FROM b;

-----------

INSERT INTO users (
    first_name,
    last_name,
    email,
    birthday,
    gender
  )
VALUES (
    'Tester1',
    'Tester1',
    'test@test',
    '1990-02-02',
    'male'
  ),
  (
    'Tester2',
    'Tester2',
    'test2@test',
    '1990-02-02',
    'male'
  ),
  (
    'Tester3',
    'Tester3',
    'test3@test',
    '1990-02-02',
    'male'
  );

SELECT * FROM users
ORDER BY id DESC;

/*
Дізнатися id юзерів, які робили замовлення
*/

SELECT id FROM users
INTERSECT
SELECT customer_id FROM orders;

/*
Дізнатися id юзерів, які не робили замовлень
*/

SELECT id FROM users
EXCEPT
SELECT customer_id FROM orders;

---- Дізнатися email людей, які ніколи замовлень не робили

SELECT email FROM users
WHERE id IN (
    SELECT id FROM users
    EXCEPT
    SELECT customer_id FROM orders);

-----------------З'єднання (соединение) - JOIN -------- 

SELECT A.v as "id",
A.t as "price",
B.v as "phone_id"
FROM a, b
WHERE a.v = b.v;

SELECT *
FROM A JOIN B ON A.v = B.v;

/*
Всі замовлення юзера з id 1865
*/

SELECT u.*, o.id AS order_id 
FROM users AS u
JOIN orders AS o
ON o.customer_id = u.id
WHERE u.id = 1865;

/*
Всі моделі телефонів, які були куплені у замовленні номер 7
*/

SELECT p.model 
FROM products AS p
JOIN orders_to_products AS otp
ON p.id = otp.product_id
WHERE otp.order_id = 7;

-----------JOIN-----------

---INNER JOIN --- перехрещення
--- Все з однієї таблиці, що міститься в другій таблиці, вибране за певною умовою

SELECT u.id, email, o.id AS order_id
FROM users AS u
JOIN orders AS o
ON u.id = o.customer_id;

----LEFT 
SELECT u.id, email, o.id AS order_id
FROM users AS u
LEFT JOIN orders AS o
ON u.id = o.customer_id;

--RIGHT
SELECT u.id, email, o.id AS order_id
FROM users AS u
RIGHT JOIN orders AS o
ON u.id = o.customer_id;

-------LEFT OUTER-----
----Інформація про користувачів, які не робили замовлень

SELECT u.id, email, o.id AS order_id
FROM users AS u
LEFT JOIN orders AS o
ON u.id = o.customer_id
WHERE o.id IS NULL;

-----FULL----

SELECT u.id, email, o.id AS order_id
FROM users AS u
FULL JOIN orders AS o
ON u.id = o.customer_id;

------------------

/* Знайти id замовлень, в яких є телефони бренду Samsung */

SELECT otp.order_id, p.model
FROM orders_to_products AS otp
JOIN products AS p
ON otp.product_id = p.id
WHERE brand = 'Samsung';

/* Кількість замовлень кожної моделі бренду Самсунг */

SELECT p.model, count(*) AS amount
FROM orders_to_products AS otp
JOIN products AS p
ON otp.product_id = p.id
WHERE brand = 'Samsung'
GROUP BY p.model;

/* Дізнатись email користувачів, які замовляли '6 model 75'   */

SELECT email
FROM users AS u
JOIN orders AS o
ON u.id = o.customer_id
JOIN orders_to_products AS otp
ON o.id = otp.order_id
JOIN products AS p
ON otp.product_id = p.id
WHERE p.model = '6 model 75';

/*
Знайти телефони, які ніхто не купував
*/

SELECT * 
FROM products AS p
LEFT JOIN orders_to_products AS otp
ON p.id = otp.product_id
WHERE otp.order_id IS NULL;

/*
Вивести id замовленнь разом з їхньою повною вартістю
(кількість*ціну телефона)
*/

SELECT otp.order_id, sum(otp.quantity*p.price)
FROM orders_to_products AS otp
JOIN products AS p
ON otp.product_id = p.id
GROUP BY otp.order_id;


/*
1. Витягти всі замовлення, в яких були куплені телефони samsung
2. Вивести мейл юзера і кількість його замовлень
3. Номери замовлень і кількість позицій в кожному замовленні
4. Знайти найпопулярніший телефон (він купувався найбільшу кількість разів).
*/


---1
SELECT otp.order_id
FROM orders_to_products AS otp
JOIN products AS p
ON otp.product_id = p.id
WHERE p.brand = 'Samsung';


---2
SELECT u.email, count(*)
FROM users AS u
JOIN orders AS o
ON u.id = o.customer_id
GROUP BY u.id;

---3
SELECT otp.order_id, count(*)
FROM orders_to_products AS otp
GROUP BY otp.order_id;


----4


/*  Знайти найпопулярніший телефон (він купувався найбільшу кількість разів).
1. Вивести всі телефони і кількість їхніх продажів
2. Відсортувати в зворотньому порядку + ліміт 1шт.
*/

SELECT p.brand, p.model, sum(otp.quantity)
FROM products AS p
JOIN orders_to_products AS otp
ON p.id = otp.product_id
GROUP BY p.model, p.brand
ORDER BY sum(otp.quantity) DESC
LIMIT 1;


/*
1. Розрахувати середній чек всього магазину (середня вартість ВСІХ замовлень)
2. Знайти користувача, який зробив найбільше замовлення в магазині.
3. Найпопулярніший бренд (сума продажів всіх екземплярів всіх моделей)
*/

---1
SELECT avg(o_w_sum.order_sum)
  FROM (
    SELECT otp.order_id, sum(p.price*otp.quantity) AS order_sum
    FROM orders_to_products AS otp
    JOIN products AS p
    ON p.id = otp.product_id
    GROUP BY otp.order_id
      ) AS o_w_sum;



---2

/* Всі юзери з сумою їхніх замовлень за весь час */
SELECT u.*, sum(otp.quantity*p.price)
FROM users AS u
JOIN orders AS o
ON u.id = o.customer_id
JOIN orders_to_products AS otp
ON o.id = otp.order_id
JOIN products AS p
ON otp.product_id = p.id
GROUP BY u.id;


SELECT u.*, sum(otp.quantity*p.price) AS total_sum
FROM users AS u
JOIN orders AS o
ON u.id = o.customer_id
JOIN orders_to_products AS otp
ON o.id = otp.order_id
JOIN products AS p
ON otp.product_id = p.id
GROUP BY u.id
ORDER BY total_sum DESC
LIMIT 1;



---3

SELECT p.brand, sum(otp.quantity) AS amount
FROM orders_to_products AS otp
JOIN products AS p
ON otp.product_id = p.id
GROUP BY p.brand
ORDER BY amount DESC
LIMIT 1;




/*
4. Витягти всі замовлення вартістю більше середнього чека магазину
5. Витягти всіх юзерів, кількість замовлень яких вище середнього
6. Витягти юзерів і кількість куплених ними моделей телефонів.
*/


/* Средний чек */
SELECT avg(o_w_sum.order_sum)
  FROM (
    SELECT otp.order_id, sum(p.price*otp.quantity) AS order_sum
    FROM orders_to_products AS otp
    JOIN products AS p
    ON p.id = otp.product_id
    GROUP BY otp.order_id
      ) AS o_w_sum;


/* Всі замовлення з їхньою вартістю */

 SELECT otp.order_id, sum(p.price*otp.quantity) AS total_amount
    FROM orders_to_products AS otp
    JOIN products AS p
    ON p.id = otp.product_id
    GROUP BY otp.order_id


    -------
    (SELECT avg(o_w_sum.order_sum)
       FROM (
            SELECT otp.order_id, sum(p.price*otp.quantity) AS order_sum
            FROM orders_to_products AS otp
            JOIN products AS p
            ON p.id = otp.product_id
            GROUP BY otp.order_id
              ) AS o_w_sum);

--- ЦЕ МОНСТР!! 
SELECT *
  FROM ( 
    SELECT otp.order_id, sum(p.price*otp.quantity) AS total_amount
    FROM orders_to_products AS otp
    JOIN products AS p
    ON p.id = otp.product_id
    GROUP BY otp.order_id) AS order_with_costs
    WHERE order_with_costs.total_amount > (SELECT avg(o_w_sum.order_sum)
       FROM (
            SELECT otp.order_id, sum(p.price*otp.quantity) AS order_sum
            FROM orders_to_products AS otp
            JOIN products AS p
            ON p.id = otp.product_id
            GROUP BY otp.order_id
              ) AS o_w_sum);


/*
WITH "псевдонім" AS (табличний вираз)
SELECT ...
FROM "псевдонім"
*/


WITH orders_with_costs AS (
    SELECT otp.order_id, sum(p.price*otp.quantity) AS total_amount
    FROM orders_to_products AS otp
    JOIN products AS p
    ON p.id = otp.product_id
    GROUP BY otp.order_id
    )
SELECT owc.*
FROM orders_with_costs AS owc
WHERE owc.total_amount > (SELECT avg(o_w_sum.order_sum)
       FROM (
            SELECT otp.order_id, sum(p.price*otp.quantity) AS order_sum
            FROM orders_to_products AS otp
            JOIN products AS p
            ON p.id = otp.product_id
            GROUP BY otp.order_id
              ) AS o_w_sum);

-----6

SELECT u.id, u.first_name, count(otp.product_id)
FROM users AS u
JOIN orders AS o
ON u.id = o.customer_id
JOIN orders_to_products AS otp
ON o.id = otp.order_id
GROUP BY u.id;