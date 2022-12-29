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