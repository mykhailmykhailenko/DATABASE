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


SELECT * FROM orders
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