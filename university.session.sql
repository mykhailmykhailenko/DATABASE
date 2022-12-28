CREATE TABLE books(
   name varchar(300),
   author varchar(300),
   type varchar(150),
   pages int,
   year date,
   publisher varchar(256)
);

/*

Створити нову БАЗУ ДАНИХ university

Сутність "студент"
- ім'я
- прізвище
- власний id 
- номер групи (посилання)

Сутність "група"
- назву
- id
- факультет (посилання)

Сутність "факультет"
- назва

Сутність "дисципліни"
- назва
- викладач

Сутність "екзамен" пов'язує студента і дисципліну.
Міститиме оцінку студента з цієї дисципліни.

Дисципліни пов'язані з факультетами. На одному факультеті викладається багато дисциплін, одна дисципліна може викладатися на декількох факультетах.

*/
CREATE TABLE student(
    first_name varchar(150),
    last_name varchar(150),
    id serial PRIMARY KEY,
    groups_number int REFERENCES groups(id)
);

CREATE TABLE groups(
    name varchar(150),
    id serial PRIMARY KEY,
    facultet int REFERENCES facultet(id)
);

CREATE TABLE facultet(
    id serial PRIMARY KEY,
    name varchar(150)
);

CREATE TABLE discipline(
    name VARCHAR(150),
    teacher varchar(150),
    id serial PRIMARY KEY
);

CREATE TABLE discipline_to_facultet (
    discipline_id int REFERENCES discipline(id),
    facultet_id int REFERENCES facultet(id),
    PRIMARY KEY (discipline_id, facultet_id)
);

CREATE TABLE exam (
    student_id int REFERENCES student(id),
    discipline_id int REFERENCES discipline(id),
    mark int CHECK (mark > 0),
    PRIMARY KEY (student_id, discipline_id)
);