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
    email varchar(300) NOT NULL UNIQUE CHECK (last_name != ''),
    birthday date CHECK (birthday < current_date),
    gender varchar(100) CHECK (last_name != '')
);

ALTER TABLE users
ADD COLUMN height numeric(3,2);

ALTER TABLE users
ADD CONSTRAINT "too_high_user" CHECK (height < 4.0);


/*
Додати юзерам нову колонку - вагу. Вага не має бути менше 0
Додати перевірку, що користувач народився не раніше 1990року.
*/

ALTER TABLE users
ADD COLUMN weight numeric(5, 2) CHECK (weight > 0);

ALTER TABLE users
ADD CONSTRAINT "too_early_birthday" CHECK (birthday > '1990-01-01');


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