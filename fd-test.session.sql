CREATE TABLE books(
   name varchar(300),
   author varchar(300),
   type varchar(150),
   pages int,
   year date,
   publisher varchar(256)
);
DROP TABLE books;

/*
створіть таблицю users
В кожного юзера має бути:
- firstName
- lastName
- email
- birthday
- gender 
*/
DROP TABLE users;

CREATE TABLE users(
    id serial PRIMARY KEY,
    first_name varchar(256) NOT NULL CHECK (first_name != ''),
    last_name varchar(256) NOT NULL CHECK (last_name != ''),
    email varchar(300) NOT NULL UNIQUE CHECK (email != ''),
    birthday date CHECK (birthday < current_date),
    gender varchar(100) CHECK (gender != '')
);

ALTER TABLE users
ADD COLUMN height numeric(3,2);

ALTER TABLE users
ADD CONSTRAINT "too_high_user" CHECK (height < 4.0);

ALTER TABLE users
DROP CONSTRAINT users_email_key;

/*
Додати юзерам нову колонку - вагу. Вага не має бути менше 0
Додати перевірку, що користувач народився не раніше 1990року.
*/

ALTER TABLE users
ADD COLUMN weight numeric(5, 2) CHECK (weight > 0);

ALTER TABLE users
ADD CONSTRAINT "too_early_birthday" CHECK (birthday > '1990-01-01');

ALTER TABLE users
DROP CONSTRAINT "too_early_birthday";   

ALTER TABLE users
ADD COLUMN is_subscribe boolean;


//table_field_check
//table_field_pkey

ALTER TABLE users
DROP CONSTRAINT "too_high_user";

INSERT INTO users (first_name, last_name, email, birthday, gender) VALUES 
('Clark', 'Kent', 'super@man.com', '2020-09-09', 'male'),
('Iron', 'Man', 'tony@mail.com', '1990-02-02', 'male'),
('Spider', 'MAn', 'peter@parker.com', '1992-02-02', 'male');

INSERT INTO users VALUES
(' ', '', 'tonestark2@com', '1892-02-02', 'male'),
('', 'Man', 'tonestark1@com', '1990-02-02', 'male'),
('She', '', 'tonestark3@com', '1992-02-02', 'female'),
(' ', ' ', ' ', NULL,NULL );

INSERT INTO users  (first_name, last_name, email, birthday, gender, height) VALUES 
('Clark', 'MArk ', 'tre@ls.s', '1990-2-2', 'male', 2.0);

/*
Створити таблицю messages
- body
- author
- created_at
- is_read
*/
DROP TABLE messages;
CREATE TABLE messages (
    id serial PRIMARY KEY,
    body text NOT NULL CHECK (body != ''),
    author varchar(200) NOT NULL,
    created_at timestamp NOT NULL CHECK (created_at <= current_timestamp) DEFAULT current_timestamp,
    is_read boolean NOT NULL DEFAULT false
);
INSERT INTO messages VALUES 
('helllo text', 'test user', '2029-09-09', false);

INSERT INTO messages (author, body) VALUES
('test user', 'hellwwwwwwwwwlo text');


----------Зв'язки (associations) ----------------

CREATE TABLE products(
    id serial PRIMARY KEY,
    name varchar(100) NOT NULL CHECK (name != ''),
    category varchar(100),
    price numeric(10, 2) NOT NULL CHECK (price > 0),
    quantity int CHECK (quantity > 0)
);
INSERT INTO products (name, price, quantity)
VALUES
('Samsung', 100, 5),
('iPhone', 500, 1),
('Sony', 200, 3);

DROP TABLE orders;

CREATE TABLE orders(
    id serial PRIMARY KEY,
    created_at timestamp DEFAULT current_timestamp,
    customer_id int REFERENCES users(id)
);

INSERT INTO orders (customer_id) VALUES
(1), (1), (2), (1), (3);

INSERT INTO orders (customer_id) VALUES
(4);

------ M:N ----- 

CREATE TABLE orders_to_products(
    product_id int REFERENCES products(id),
    order_id int REFERENCES orders(id),
    quantity int CHECK (quantity > 0),
    PRIMARY KEY (product_id, order_id)
);

INSERT INTO orders_to_products (product_id, order_id, quantity) VALUES
(1, 1, 1),
(2, 1, 1),
(3, 1, 1);



/*
Завдання:
Створити таблицю юзерів
- id
- first_name
-last_name
-email
-birthday
-gender
Створити таблицю повідомлень
- author ----> user
- body 
- created_at default now
- is_read
Юзери об'єднуються в чати. В одному чаті - багато юзерів, в одного юзера - багато чатів.
Юзери відправляють повідомлення. Одне повідомлення може бути тільки в одному чаті. Але в чаті може бути багато повідомлень
*/

CREATE TABLE messages (
    id serial PRIMARY KEY,
    author_id int REFERENCES users(id),
    body text NOT NULL CHECK (body != '') ,
    created_at timestamp NOT NULL DEFAULT current_timestamp,
    is_read boolean DEFAULT false
);

ALTER TABLE messages
ADD COLUMN chat_id int REFERENCES chats(id);

/*
PRIMARY KEY - первинний ключ - це NOT NULL + UNIQUE
FOREIGN KEY - зовнішній ключ - це NOT NULL + посилання на стовбець іншої таблиці -> Ми не можемо
записати сюди значення, яких не існує у головній таблиці (на яку ми ссилаємось)
*/

CREATE TABLE chats (
    id serial PRIMARY KEY,
    name varchar(200),
    owner_id int REFERENCES users(id),
    created_at timestamp NOT NULL DEFAULT current_timestamp
);

DROP TABLE users_to_chats;

CREATE TABLE users_to_chats(
    chat_id int REFERENCES chats(id),
    user_id int REFERENCES users(id) ON DELETE CASCADE,
    PRIMARY KEY (chat_id, user_id)
);

-------

INSERT INTO chats (name, owner_id) VALUES
('First chat', 1);

INSERT INTO users_to_chats VALUES
(1, 1), (1,2), (1,3);

INSERT INTO messages (author_id, body, chat_id) VALUES 
(1, 'hello', 1), (2, 'hello yourself', 1);


-------------------

/*
Сутність контенту.
У контенту є:
- назва (об.)
- опис (необ.)
- дата створення
Є сутність реакцій.
Реакція -> like : true
        -> dislike : false
        -> null (реакції немає, або вона знята користувачем)
Реакція - це зв'язок між контентом і користувачем
*/


CREATE TABLE contents(
    id serial PRIMARY KEY,
    name varchar(300) NOT NULL CHECK (name != ''),
    description text,
    created_at timestamp DEFAULT current_timestamp
);

CREATE TABLE reactions (
    content_id int REFERENCES contents(id),
    user_id int REFERENCES users(id),
    reaction boolean,
    PRIMARY KEY (content_id, user_id)
);


-------1:1--------

/*
Тренер - команда
*/

--створюємо першу без посилання
CREATE TABLE coaches(
    id serial PRIMARY KEY,
    name varchar(300)
    -- team_id int REFERENCES team(id)
);

--створюємо другу
CREATE TABLE teams (
    id serial PRIMARY KEY,
    name varchar(300),
    coach_id int REFERENCES coaches(id)
);

--редагуємо першу, додавши до неї посилання
ALTER TABLE coaches
ADD COLUMN team_id int REFERENCES teams(id);

--------delete-------

ALTER TABLE coaches
DROP COLUMN team_id;

DROP TABLE teams;

DROP TABLE coaches;


------UPDATE, DELETE--------

UPDATE users
SET last_name = 'Doe'
WHERE id = 1;

UPDATE users
SET last_name = 'Man'
WHERE id = 3;

---Встановити вагу в 60кг всім хто народився після 1 січня 1990 року

UPDATE users
SET weight = 60
WHERE birthday > '1990-01-01';

DELETE FROM users
WHERE id = 5;

INSERT INTO users (
    first_name,
    last_name,
    email,
    birthday,
    gender
  )

VALUES (
  'John', 'Doe', 'doe!doe', '1999-09-09', 'female'
);

INSERT INTO users_to_chats VALUES
(1, 7);

--не вийде!
UPDATE users
SET id = 5
WHERE id = 7;

---------------SELECT---------
SELECT * FROM users;

SELECT * FROM users
WHERE weight = 60;

-----Спитати всіх юзерів, які народились після 1992 року

SELECT * FROM users
WHERE birthday > '1992.01.01';


/*
Створити нову БАЗУ ДАНИХ university
Сутність "студент"
- ім'я
- прізвище
- власний id 
- номер групи
Сутність "група"
- назву
- id
- факультет
Сутність "факультет"
- назва
Сутність "дисципліни"
- назва
- викладач
Сутність "екзамен" пов'язує студента і дисципліну.
Міститиме оцінку студента з цієї дисципліни.
Дисципліни пов'язані з факультетами. На одному факультеті викладається багато дисциплін, одна дисципліна може викладатися на декількох факультетах.
*/