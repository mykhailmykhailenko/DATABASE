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