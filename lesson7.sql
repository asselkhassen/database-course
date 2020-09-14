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

INSERT INTO users_task_one (email,pass,name,surname,phone,gender,birthday,hometown,created_at,updated_at)
values
	('asselkhassen@gmail.com', 'qwerty', 'Assel', 'Khassen', 87776667766, 'f', '1996-01-20', 'Astana', '2017-10-20 08:10:00', '2016-11-25 15:00:00'),
	('aleksey1@gmail.com', 'rtyut', 'Aleksey', 'Ivanov', 8777493028, 'm', '1990-06-10', 'Moscow', '2018-09-30 05:00:00', '2014-11-16 10:00:00'),
	('madina1@gmail.com', 'qwerty', 'Madina', 'Ilyasova', 8667537291, 'f', '1993-01-25', 'Almaty', '2019-07-14 19:15:00', '2017-10-17 04:10:00'),
	('petr1@gmail.com', 'frgrtgrf', 'Petr', 'Petrov', 89997783244, 'm', '1989-11-29', 'Saint_Petesburg', '2010-09-18 08:17:00', '2020-05-16 17:12:00'),
	('khamit1@gmail.com', 'qwerfrrty', 'Khamit', 'Tukenbayev', 83562354287, 'm', '1993-08-16', 'Astana', '2007-05-25 05:55:00', '2013-11-27 08:10:00');

DROP TABLE IF EXISTS orders;
CREATE TABLE orders(
  id SERIAL PRIMARY KEY,
  user_id bigint unsigned not null,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  foreign key (user_id) references users_task_one(id)
);

INSERT INTO orders(user_id, created_at, updated_at)
values
	(1, '2017-10-20 08:10:00', '2016-11-25 15:00:00'),
	(1, '2018-09-30 05:00:00', '2014-11-16 10:00:00'),
	(4, '2019-07-14 19:15:00', '2017-10-17 04:10:00'),
	(3, '2010-09-18 08:17:00', '2020-05-16 17:12:00'),
	(5, '2007-05-25 05:55:00', '2013-11-27 08:10:00');


DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  UNIQUE unique_name(name(10))
);

INSERT INTO catalogs VALUES
  (1, 'Процессоры'),
  (2, 'Материнские платы'),
  (3, 'Видекарты'),
  (4, 'Мониторы'),
  (5, 'Блоки');

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  desription TEXT,
  price DECIMAL (11,2),
  catalog_id bigint UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id),
  foreign key (catalog_id) references catalogs(id)
);

INSERT INTO products
  (name, desription, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'description1', 7890.00, 1),
  ('Intel Core i5-7400', 'description2', 12700.00, 1),
  ('AMD FX-8320E', 'description3', 4780.00, 1),
  ('AMD FX-8320', 'description4', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'description5', 19310.00, 2),
  ('Gigabyte H310M S2H', 'description6', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'description7', 5060.00, 2);


DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products(
  id SERIAL PRIMARY KEY,
  order_id bigint UNSIGNED,
  product_id bigint UNSIGNED,
  total INT UNSIGNED DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  foreign key (order_id) references orders(id),
  foreign key (product_id) references products(id)
);

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id SERIAL PRIMARY KEY,
  user_id bigint UNSIGNED,
  product_id bigint UNSIGNED,
  discount FLOAT UNSIGNED,
  started_at DATETIME,
  finished_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id),
  foreign key (user_id) references users_task_one(id),
  foreign key (product_id) references products(id)
);

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id bigint UNSIGNED,
  product_id bigint UNSIGNED,
  value INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  foreign key (storehouse_id) references storehouses(id),
  foreign key (product_id) references products(id)
);


-- Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

select users_task_one.id as user_id, users_task_one.name as user_name, count(*) as total_orders
from users_task_one
right join orders on users_task_one.id=orders.user_id
group by user_id, user_name;

-- Выведите список товаров products и разделов catalogs, который соответствует товару.

select 
	products.name, products.price, catalogs.name 
	from 
		products as products
	join
		catalogs as catalogs
	on 
		products.catalog_id=catalogs.id;
		
	
	