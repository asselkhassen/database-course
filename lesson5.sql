-- 1. ѕусть в таблице users пол€ created_at и updated_at оказались незаполненными. «аполните их текущими датой и временем.

drop table if exists users_task_one;
create table users_task_one(
	id serial primary key,
	email varchar(150) unique,
	pass varchar(100),
	name varchar(50),
	surname varchar(50),
	phone varchar(20),
	gender char(1),
	birthday date,
	hometown varchar(100),
	created_at datetime,
	updated_at datetime,
	key(phone),
	key(name, surname)	
);

INSERT INTO example.users_task_one (email,pass,name,surname,phone,gender,birthday,hometown,created_at,updated_at)
values
	('assel@gmail.com', 'qwerty', 'Assel', 'Khassen', 87776667766, 'f', '1996-01-20', 'Astana', NULL, NULL),
	('aleksey@gmail.com', 'rtyut', 'Aleksey', 'Ivanov', 8777493028, 'm', '1990-06-10', 'Moscow', NULL, NULL),
	('madina@gmail.com', 'qwerty', 'Madina', 'Ilyasova', 8667537291, 'f', '1993-01-25', 'Almaty', NULL, NULL),
	('petr@gmail.com', 'frgrtgrf', 'Petr', 'Petrov', 89997783244, 'm', '1989-11-29', 'Saint_Petesburg', NULL, NULL),
	('khamit@gmail.com', 'qwerfrrty', 'Khamit', 'Tukenbayev', 83562354287, 'm', '1993-08-16', 'Astana', NULL, NULL);
	
update users_task_one set created_at=now(), updated_at=now();

select id, created_at, updated_at from users_task_one;

-- 2. “аблица users была неудачно спроектирована. «аписи created_at и updated_at были заданы типом VARCHAR и в них долгое врем€ 
-- помещались значени€ в формате 20.10.2017 8:10. Ќеобходимо преобразовать пол€ к типу DATETIME, сохранив введЄнные ранее значени€.

drop table if exists users_task_two;
create table users_task_two(
	id serial primary key,
	email varchar(150) unique,
	pass varchar(100),
	name varchar(50),
	surname varchar(50),
	phone varchar(20),
	gender char(1),
	birthday date,
	hometown varchar(100),
	created_at varchar(255),
	updated_at varchar(255),
	key(phone),
	key(name, surname)	
);

INSERT INTO example.users_task_two (email,pass,name,surname,phone,gender,birthday,hometown,created_at,updated_at)
values
	('assel@gmail.com', 'qwerty', 'Assel', 'Khassen', 87776667766, 'f', '1996-01-20', 'Astana', '20.10.2017 8:10', '25.11.2016 15:00'),
	('aleksey@gmail.com', 'rtyut', 'Aleksey', 'Ivanov', 8777493028, 'm', '1990-06-10', 'Moscow', '30.09.2018 5:00', '16.11.2014 10:00'),
	('madina@gmail.com', 'qwerty', 'Madina', 'Ilyasova', 8667537291, 'f', '1993-01-25', 'Almaty', '14.07.2019 19:15', '17.10.2017 4:10'),
	('petr@gmail.com', 'frgrtgrf', 'Petr', 'Petrov', 89997783244, 'm', '1989-11-29', 'Saint_Petesburg', '18.09.2010 8:17', '16.05.2020 17:12'),
	('khamit@gmail.com', 'qwerfrrty', 'Khamit', 'Tukenbayev', 83562354287, 'm', '1993-08-16', 'Astana', '25.05.2007 5:55', '27.11.2013 8:10');

update users_task_two
set
	created_at = str_to_date(created_at, '%d.%m.%Y %k:%i'),
	updated_at = str_to_date(updated_at, '%d.%m.%Y %k:%i');

ALTER TABLE users_task_two
MODIFY COLUMN created_at datetime default current_timestamp;

ALTER TABLE users_task_two
MODIFY COLUMN updated_at datetime default current_timestamp;
	
select id, created_at, updated_at from users_task_two;

-- 3. ¬ таблице складских запасов storehouses_products в поле value могут встречатьс€ самые разные цифры: 0, если товар закончилс€ 
-- и выше нул€, если на складе имеютс€ запасы. Ќеобходимо отсортировать записи таким образом, чтобы они выводились в пор€дке 
-- увеличени€ значени€ value. ќднако нулевые запасы должны выводитьс€ в конце, после всех записей.

drop table if exists storehouses_products;
create table storehouses_products(
	id serial primary key,
	product_id bigint unsigned not null,
	value int
);

INSERT INTO example.storehouses_products (id,product_id,value)
VALUES 
	(1, 232, 0),
	(2, 2342, 2500),
	(3, 772, 0),
	(4, 245, 30),
	(5, 542, 500),
	(6, 772, 1);

select * from storehouses_products order by if(value>0,0,1), value;

-- јгрегаци€ данных 1.ѕодсчитайте средний возраст пользователей в таблице users.

select avg(timestampdiff(year, birthday, now())) as avg_age from users_task_one;

-- 2. ѕодсчитайте количество дней рождени€, которые приход€тс€ на каждый из дней недели. —ледует учесть, что необходимы 
-- дни недели текущего года, а не года рождени€.

select dayname(date_add(birthday, interval (2020 - year(birthday)) year)) as this_year_bd, count(*) 
from users_task_one group by this_year_bd;
