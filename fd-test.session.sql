CREATE TABLE books(
   name varchar(300),
   author varchar(300),
   type varchar(150),
   pages int,
   year date,
   publisher varchar(256)
);


/*
створіть таблицю users
В кожного юзера має бути:
- firstName
- lastName
- email
- birthday
- gender 
*/

CREATE TABLE users(
    first_name varchar(256),
    last_name varchar(256),
    email varchar(300),
    birthday date,
    gender varchar(100)
);


INSERT INTO users VALUES 
('Clark', 'Kent', 'super@man.com', '1990-09-09', 'male');


INSERT INTO users VALUES
('Iron', 'Man', 'tonestark@com', '1892-02-02', 'male'),
('Spider', 'Man', 'peter@parker.com', '1990-02-02', 'male'),
('She', 'Halk', 'jane@lawyer.com', '1992-02-02', 'female'),
('Loki', 'Odinsson', 'loki@loki', '1000-10-10', 'male');