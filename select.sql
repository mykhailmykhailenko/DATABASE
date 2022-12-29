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