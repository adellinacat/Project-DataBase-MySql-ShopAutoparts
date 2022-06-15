# Представленная база данных предназначена для обеспечения функционирования портала магазина по продаже автомобильных запчастей.
# Структура базы данных позволяет вести складской учёт товаров, фиксировать продажи, вести историю заказов покупателями.
# Также, возможно использование БД в качестве основы для реализации интернет-магазина, за счёт наличия структуры категоризации товаров по типам и применяемости
# Для сокращения времени исполнения типовых запросов, реализован ряд представоений, например: 
# представление, определяющее количество заказов для каждого пользователя. Данный функионал позволяет быстро находить постоянных заказчиков и анализировать из активность, учитывая потребности;
# представление, которое выводит отаток товара на каждом складе, т.н. поиск по складам. Это позволяет быстро находить, на каком из складов есть товар, в каком количестве и строить логистику.
# Кроме того, использованы простые и обединенные запросы, как пример, для демонстрации функционирования БД и согласованности ее данных, такие, как:
# запрос на поиск всех заказов заданного пользователя;
# список подразделов subcatalogs и рубрик catalogs, которые соответствуют подразделу;
# определение названия каталога, в котором присутствует самая дорогая товарная позиция.
# Для обработки клиентской базы и хранения архива данных по заказам создана хранимая процедура `history_orders`, которая при помощи триггеров собирает информацию о заказах, составах заказов и заказчиках.

****************************************************

DROP DATABASE IF EXISTS shop_autoparts;
CREATE DATABASE shop_autoparts;
USE shop_autoparts;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Группа запчастей',
  UNIQUE unique_name(name(100))
) COMMENT = 'Разделы магазина';

INSERT INTO catalogs VALUES
  (DEFAULT, 'Детали для ТО'),
  (DEFAULT, 'Двигатель'),
  (DEFAULT, 'Топливная система'),
  (DEFAULT, 'Система выпуска'),
  (DEFAULT, 'Трансмиссия'),
  (DEFAULT, 'Ходовая часть'),
  (DEFAULT, 'Рулевое управление'),
  (DEFAULT, 'Тормозная система'),
  (DEFAULT, 'Электрооборудование'),
  (DEFAULT, 'Детали кузова'),
  (DEFAULT, 'Система охлаждения'),
  (DEFAULT, 'Отопление/кондиционирование'),
  (DEFAULT, 'Детали салона'),
  (DEFAULT, 'Дополнительное оборудование');
  
  
DROP TABLE IF EXISTS subcatalogs;
CREATE TABLE subcatalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Подгруппа запчастей',
  catalog_id BIGINT UNSIGNED,    
  FOREIGN KEY (catalog_id) REFERENCES catalogs (id)
  KEY index_of_catalog_id (catalog_id) COMMENT = 'Разделы каталога'
 );
 
 INSERT INTO subcatalogs 
	(id, name, catalog_id) VALUES 
    (DEFAULT, 'Фильтр масляный', 1), 
    (DEFAULT, 'Фильтр воздушный', 1), 
    (DEFAULT, 'Фильтр салонный', 1), 
    (DEFAULT, 'Фильтр топливный', 1), 
    (DEFAULT, 'Комплект фильтров', 1), 
    (DEFAULT, 'Свечи зажигания', 1), 
    (DEFAULT, 'Тормозные колодки', 1), 
    (DEFAULT, 'Прокладки', 2), 
    (DEFAULT, 'Система подачи воздуха', 2), 
    (DEFAULT, 'Механизм газораспределения', 2), 
    (DEFAULT, 'Электроника двигателя', 2),    
    (DEFAULT, 'Крепление двигателя', 2), 
    (DEFAULT, 'Ременный привод', 2), 
    (DEFAULT, 'Система зажигания', 2), 
    (DEFAULT, 'Бак топливный', 3), 
    (DEFAULT, 'Фильтр топливный', 3), 
    (DEFAULT, 'Датчик уровня топлива', 3), 
    (DEFAULT, 'Насос топливный/комплектующие', 3),    
    (DEFAULT, 'Глушитель в сборе', 4), 
    (DEFAULT, 'Катализатор', 4), 
    (DEFAULT, 'Датчик кислорода', 4), 
    (DEFAULT, 'Коллектор', 4), 
    (DEFAULT, 'Трубы', 4), 
    (DEFAULT, 'Система сцепления', 5),    
    (DEFAULT, 'МКПП', 5), 
    (DEFAULT, 'АКПП', 5), 
    (DEFAULT, 'Привод колеса', 5), 
    (DEFAULT, 'Главная передача', 5), 
    (DEFAULT, 'Пружина подвески', 6), 
    (DEFAULT, 'Амортизатор/опора амортизатора подвески', 6), 
    (DEFAULT, 'Рычаги/тяги подвески', 6), 
    (DEFAULT, 'Стабилизаторы/крепления', 6), 
    (DEFAULT, 'Ступица колеса', 6), 
    (DEFAULT, 'Подвеска оси', 6),
    (DEFAULT, 'Рейка рулевая/насос ГУР', 7),
    (DEFAULT, 'Шарниры', 7),
    (DEFAULT, 'Тяга рулевая/наконечник РТ', 7),
    (DEFAULT, 'Дисковый тормоз', 8),
    (DEFAULT, 'Тросы, тяги, рычаги тормозной системы', 8),
    (DEFAULT, 'Стояночный тормоз', 8),
    (DEFAULT, 'Шланги тормозные', 8),
    (DEFAULT, 'Главный тормозной цилиндр', 8),
    (DEFAULT, 'Суппорт тормозной', 8),
    (DEFAULT, 'Стартер', 9),
    (DEFAULT, 'Генератор', 9),
    (DEFAULT, 'Аккумулятор', 9),
    (DEFAULT, 'Головной свет', 9),
    (DEFAULT, 'Дополнительный свет', 9),
    (DEFAULT, 'Датчики', 9),
    (DEFAULT, 'Приборы управления', 9),
    (DEFAULT, 'Приборы контроля', 9),
    (DEFAULT, 'Передняя часть кузова', 10),
    (DEFAULT, 'Задняя часть кузова', 10),
    (DEFAULT, 'Остекление', 10),
    (DEFAULT, 'Облицовка, защитные накладки, эмблемы', 10),
    (DEFAULT, 'Газовые пружины', 10),
    (DEFAULT, 'Термостат/прокладка термостата', 11),
    (DEFAULT, 'Радиатор масляный/водяной', 11),
    (DEFAULT, 'Патрубки системы охлаждения', 11),
    (DEFAULT, 'Насос системы охлаждения', 11),
    (DEFAULT, 'Вентилятор охлаждения', 11), 
    (DEFAULT, 'Кондиционер', 12),
    (DEFAULT, 'Отопление', 12),
    (DEFAULT, 'Органы управления автомобилем', 13),
    (DEFAULT, 'Накладки, эмблемы, молдинги', 13),
    (DEFAULT, 'Багажник', 13),
    (DEFAULT, 'Окна/двери', 13),
    (DEFAULT, 'Прицепное оборудование', 14),
    (DEFAULT, 'Система безопасности', 14);
    
DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  part_code_id VARCHAR(255) COMMENT 'Код детали',    
  manufacturer VARCHAR(100) COMMENT 'Производитель',
  name VARCHAR(255) COMMENT 'Наименование',
  description TEXT COMMENT 'Описание',
  price INT UNSIGNED COMMENT 'Цена',
  multiplicity INT UNSIGNED COMMENT 'Кратность',     
  product_catalog_id BIGINT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 FOREIGN KEY (product_catalog_id) REFERENCES subcatalogs (catalog_id)
#UNIQUE KEY part_code_id (part_code_id)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
 
INSERT INTO products
  (id, part_code_id, manufacturer, name, description, price) VALUES
  (DEFAULT, '20201AC110', 'SUBARU', 'Сайлентблок передний левый зад.рычага', 'Сайлентблок левый переднего нижнего рычага задний SUBARU Forester, Legacy, Outback 1996-2004', 4416),
  (DEFAULT, '19347939', 'GM', 'АМОРТИЗАТОР ЗАДНИЙ', 'Амортизатор задний газовый Opel Corsa, Fiat Grande Punto all 05', 6642),
  (DEFAULT, '42039545SX', 'STELLOX', 'АМОРТИЗАТОР ЗАДНИЙ', 'Амортизатор задний газовый Opel Corsa, Fiat Grande Punto all 05', 1324),
  (DEFAULT, '32120272', 'SENSEN', 'Амортизатор газ.задний', 'Амортизатор OPEL VECTRA C/SIGNUM 1,6-3,2V6C 04.2002-- газ.задний', 2150),
  (DEFAULT, '20201AC111', 'SUBARU', 'Сайлентблок передний правый зад.рычага', 'Сайлентблок правый переднего нижнего рычага задний SUBARU Forester, Legacy, Outback 1996-2004', 3998),
  (DEFAULT, '19348776', 'ACDELCO', 'КАТУШКА ЗАЖИГАНИЯ', 'ACDelco Модуль зажигания Astra-J, Corsa-D, Insignia, Mokka, Meriva-B, Zafira-C', 8143),
  (DEFAULT, '1K0698451G', 'VAG', 'Колодки тормозные задние', 'Колодки задние Street Performance Ceramic', 6500),
  (DEFAULT, '5K0698151', 'VAG', 'Колодки тормозные передние', 'Колодки передние Street Performance Ceramic', 4150),
  (DEFAULT, 'D1060-4BA0A', 'NISSAN', 'Колодки тормозные передние', 'Pad Kit-Disc Brake D1060-4BA0A Nissan', 15500),
  (DEFAULT, 'MSC2016', 'MASUMA', 'Колодки тормозные передние', 'Kолодки дисковые передние Nissan Qashqai 1.6/2.0/1.5dCi/1.6dCi 13', 4670),
  (DEFAULT, '5171226100', 'HYUNDAI', 'Диск тормозной перед 4WD', 'Диск тормозной вентилируемый Santa Fe 2000-2005 G6BA КПП автомат 4х4 (АКПП) 2003', 4900),
  (DEFAULT, '8450033130', 'LADA', 'ФИЛЬТР ВОЗДУШНЫЙ', 'Фильтр воздушный RENAULT DUSTER VESTA X-RAY с 2019г', 890),
  (DEFAULT, 'GB-95090', 'BIGFilter', 'ФИЛЬТР ВОЗДУШНЫЙ', 'Фильтр воздушный LADA Largus / Vesta / X-Ray (двиг. ВАЗ) 07.2019-> BIG FILTER GB-95090 LADA Largus / Vesta / X-Ray (двиг. ВАЗ) 07.2019', 465),
  (DEFAULT, 'AG687', 'GOODWILL', 'Фильтр возд.', 'Фильтр возд. LADA (VAZ) VESTA 1.6 (16V) 106 л.с. 07 2019 - н.в.', 832),
  (DEFAULT, '45620000', 'FAD', 'Тяга рулевая продольная L', 'Тяга рулевая продольная L=847 mm MERCEDES BENZ', 12113),
  (DEFAULT, '26117610061', 'BMW', 'Муфта кардана', 'Муфта эластичная карданного вала', 14000),
  (DEFAULT, '24118612901', 'BMW', 'ФИЛЬТР АКПП', 'Поддон картера АКПП (с фильтром и прокладкой)', 7890),
  (DEFAULT, '11127567877', 'BMW', 'ПРОКЛАДКА КЛАПАННОЙ КРЫШКИ', 'КОМПЛЕКТ ПРОФИЛЬНЫХ ПРОКЛАДОК', 2788),
  (DEFAULT, 'LRH0998', 'LUZAR', 'Радиатор отопителя (теплообменник)', 'Радиатор отоп. для а/м Лада Largus (12-)/Renault Logan (04-) (алюм.) (LRh 0998)', 1766),
  (DEFAULT, '15646523', 'BMW', 'Наконечник провода к свече зажигания', 'НАКОНЕЧНИК ПРОВОДА К СВЕЧЕ ЗАЖИГАНИЯ', 2223),
  (DEFAULT, '06D903137C', 'BOSCH', 'Ремень поликлиновой', 'Ремень генератора BOSCH 1987946014 6pk1570', 990),
  (DEFAULT, '6PK1600', 'GATES', 'РЕМЕНЬ РУЧЕЙКОВЫЙ', 'Ремень поликлиновой Chrysler / Peugeot / Renault', 1840),
  (DEFAULT, '8708929000', 'TRANSMASTER UNIVERSAL', 'Глушитель основной', 'Глушитель ВАЗ 2102-04 нерж.покр.(Универсал TR) TR', 2142),
  (DEFAULT, '963023520R', 'LADA', 'Зеркало заднего вида левое', 'ЗЕРКАЛО LARGUS RENAULT ЗАДНЕГО ВИДА ЛЕВОЕ 6001549', 4990),
  (DEFAULT, '963023520L', 'LADA', 'Зеркало заднего вида правое', 'ЗЕРКАЛО LARGUS RENAULT ЗАДНЕГО ВИДА правое 6001549', 3169),
  (DEFAULT, '2710', 'ABAP', 'Выключатель аварийн/сигнала', 'Выключатель аварийн/сигнала ВАЗ 2108-099 б/подсветки', 1300),
  (DEFAULT, '2710', 'CLIMAIR', 'К-Т ВЕТРОВИКОВ ЗАД', 'К-Т ВЕТРОВИКОВ ЗАД.ACURA MDX 5ДВ.00', 1504),
  (DEFAULT, '2710', 'AUGER', 'САЙЛЕНТБЛОК', 'САЙЛЕНТБЛОК ПЕРЕДНЕГО СТАБИЛИЗАТОРА MB TRUCK ATEGO1', 514),
  (DEFAULT, '7318159000', 'БЕЛЗАН', 'Комплект №35 крепления стойки развал схождение', 'Комплект №35 крепления стойки развал схождение ВАЗ 2108-2115 Белебей', 100),
  (DEFAULT, '8708109000', 'ГАЗ', 'Цилиндр задний тормозной', 'Цилиндр задний тормозной (D 10 мм) ГАЗель', 701),
  (DEFAULT, 'CF724', 'TRIALLI', 'Цилиндр тормозной задний', 'Цилиндр тормозной задний для а/м ГАЗ 2410 (O 28)', 632),
  (DEFAULT, 'AC2505', 'KITTO', 'Фильтр салонный угольный', 'Фильтр салонный AC-2505 ECOCON AC-2505', 512),
  (DEFAULT, 'CF72C', 'FI BA', 'Фильтр салонный', '	Фильтр салона NISSAN MICRA 92-03', 264),
  (DEFAULT, '56784900', 'JAPANPARTS', 'ФИЛЬТР САЛОНА', 'FAA-NS2_фильтр салона! \ Nissan Micra 1.0I/1.3I/1.4I/1.5D 92-03', 396),
  (DEFAULT, '3926909109', 'ACTEPA', 'Стекло передней фары', 'Стекло передней фары ВАЗ 2115 правое, 743', 154),
  (DEFAULT, '3820111-D07', 'GREAT WALL', 'ДАТЧИК СКОРОСТИ', 'ДАТЧИК СКОРОСТИ GW DEER, SAFE, SAILOR 4x4 - 3820111-B06', 500),
  (DEFAULT, '1516730PART2', 'FORD', 'ШЛАНГОПРОВОД', 'ШЛАНГОПРОВОД', 1590),
  (DEFAULT, '06D903157А', 'GATES', 'Ремень', 'Ремень привода 1987946014 6pk1570', 1269),
  (DEFAULT, 'VSK-00150085', 'AGATEK', 'КОВРИКИ В САЛОН', 'АГАТЭК Коврики салона ВАЗ 2190 Гранта резиновые с литой перемычкой', 404),
  (DEFAULT, 'UVWAMA011', 'АВТОУПОР', 'Газовые упоры капота', 'Газовые упоры капота АвтоУпор для Volkswagen Amarok (V - 2.0) 2010-04.2017, 2 шт., UVWAMA011', 2379),
  (DEFAULT, 'UMACX5012', 'RIVAL', 'Амортизатор капота', 'Амортизаторы капота Mazda CX-5 2011-', 1700),
  (DEFAULT, '9025192000', 'LUZAR', 'Датчик вентилятора 87/82С', 'Датчик вент. для а/м Лада 2103-07, АЗЛК 2141 87/82С (LS 0241)', 183),
  (DEFAULT, '06D903157C', 'GATES', 'Ремень поликлиновой', 'Ремень генератора 1987946014 6pk1570', 1590);
  
DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Склад';

INSERT INTO storehouses (id, name) VALUES 
(DEFAULT, 'Склад № 1 МЕДВЕДКОВО'),
(DEFAULT, 'Склад № 2 СТРОГИНО'),
(DEFAULT, 'Склад № 3 АНИНО');


DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id BIGINT UNSIGNED,
  product_id BIGINT UNSIGNED,
  `value` INT UNSIGNED COMMENT 'Кол-во товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (storehouse_id) REFERENCES storehouses (id),
  FOREIGN KEY (product_id) REFERENCES products (id)
) COMMENT = 'Складской остаток';

INSERT INTO storehouses_products (id, storehouse_id, product_id, value)
VALUES 
 (DEFAULT, 1, 1, 25),
 (DEFAULT, 1, 2, 10),
 (DEFAULT, 1, 3, 4),
 (DEFAULT, 1, 4, 8),
 (DEFAULT, 1, 5, 27),
 (DEFAULT, 1, 6, 100),
 (DEFAULT, 1, 7, 10),
 (DEFAULT, 1, 8, 3),
 (DEFAULT, 1, 9, 13),
 (DEFAULT, 1, 10, 15),
 (DEFAULT, 1, 11, 89),
 (DEFAULT, 1, 12, 4),
 (DEFAULT, 1, 13, 1),
 (DEFAULT, 1, 14, 5),
 (DEFAULT, 1, 15, 15),
 (DEFAULT, 1, 16, 20),
 (DEFAULT, 1, 17, 200),
 (DEFAULT, 2, 18, 30),
 (DEFAULT, 2, 19, 21),
 (DEFAULT, 2, 20, 12),
 (DEFAULT, 2, 21, 25),
 (DEFAULT, 2, 22, 66),
 (DEFAULT, 2, 23, 166),
 (DEFAULT, 2, 24, 25),
 (DEFAULT, 2, 25, 125),
 (DEFAULT, 2, 26, 5),
 (DEFAULT, 2, 27, 0),
 (DEFAULT, 2, 28, 0),
 (DEFAULT, 2, 29, 1),
 (DEFAULT, 2, 30, 10),
 (DEFAULT, 3, 31, 40),
 (DEFAULT, 3, 32, 0),
 (DEFAULT, 3, 33, 1),
 (DEFAULT, 3, 34, 33),
 (DEFAULT, 3, 35, 1),
 (DEFAULT, 3, 36, 1),
 (DEFAULT, 3, 37, 1),
 (DEFAULT, 3, 38, 0),
 (DEFAULT, 3, 39, 45),
 (DEFAULT, 3, 40, 100),
 (DEFAULT, 3, 41, 0),
 (DEFAULT, 3, 42, 9),
 (DEFAULT, 3, 43, 9);
 
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  firstname VARCHAR(255) COMMENT 'Имя покупателя',
  lastname VARCHAR(255) COMMENT 'Фамилия покупателя',
  `email` VARCHAR(120) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` BIGINT(20) UNSIGNED DEFAULT NULL,
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`),
  KEY `users_firstname_lastname_idx` (`firstname`,`lastname`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT = 'Покупатели';

INSERT INTO users VALUES 
('1','Javonte','Jakubowski', 'trey62@example.net', '89676723604'),
('2','Aurelia','Ratke', 'rrolfson@example.org', '89339101296'),
('3','Jacey','Fritsch', 'stone96@example.com', '89802518644'),
('4','Whitney','Jerde', 'jonathon.feil@example.com', '89397268208'),
('5','Axel','Lynch', 'ckuhic@example.org', '89585747656'),
('6','Karlee','Kunde', 'syost@example.org', '89125986482'),
('7','Ryann','Prosacco', 'malvina.toy@example.net', '89334895548'),
('8','Ona', 'Schumm', 'adelia91@example.com', '89838377175'),
('9','Kennith','Gaylord', 'alphonso71@example.com', '89777246849'),
('10','Alexandre','Rowe', 'esipes@example.net', '89230775666'),
('11','Laurie','Green', 'mnicolas@example.net', '89532268940'),
('12','Rahsaan','Schowalter', 'gerhold.savanah@example.net', '89858737516'),
('13','David','Carter', 'anderson.shields@example.net', '89591339172'),
('14','Lea','Hilpert', 'mccullough.jed@example.net', '89893980394'),
('15','Christ','Reilly', 'kautzer.citlalli@example.com', '89893222707'),
('16','Madge','Conroy', 'joanie.predovic@example.org', '89663964178'),
('17','Luisa','Weber', 'gerda.o\'keefe@example.net', '89781923197'),
('18','Rubye','Upton', 'ray48@example.com', '89999819313'),
('19','Mikayla','Cole', 'jessica73@example.com', '89030626823'),
('20','Roberto','Zemlak', 'ukuvalis@example.net', '89180780906');

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
  user_id BIGINT(20) UNSIGNED NOT NULL,
  gender CHAR(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  birthday DATE DEFAULT NULL,
  car_model VARCHAR(100) COMMENT 'Модель авто',
  address VARCHAR(255) COLLATE utf8_unicode_ci DEFAULT NULL,    
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY user_id (user_id),
  CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `profiles` (user_id, gender, birthday, car_model, address)
VALUES
(1,'m','1974-08-12', 'VOLVO F7', '129345, Москва, ул. Корнейчука, д.15, кв.5'),
(2,'f','1990-02-25', 'OPEL Astra', '102336, Москва, пр-т Вернадского, д.31, к5а, кв.88'),
(3,'f','1998-10-01', 'TOYOTA Corola', '122336, Москва, пр-т Мира, д.104, кв.103'),
(4,'f','1980-03-08', 'NISSAN Teana', '101102, Москва, ул.Подколокольная, д.14, к2в, кв.78'),
(5,'m','1998-12-20', 'BMW i255', '124568 Москва, ул. Лескова'),
(6,'f','1989-05-04', 'Ford Focus II', 'г.Москва'),
(7,'m','2000-12-31', 'Ford S-Max', '111556, Санкт-Петербург, ул. Россошанская, д.14'),
(8,'f', '1971-10-10', 'AUDI', '115112, г.Пермь'),
(9,'m','1985-06-30', 'BMW', '122965, Москва, ул.Островитянова, д.2, кв.1'),
(10,'m','1965-01-25', 'LADA Vesta', '124982, Москва, Новопесковский пер. д.124'),
(11,'f','1952-09-18', 'ГАЗ2110', '123456, Москва, ул. Летная, д.56, стр.5, кв.102'),
(12,'m','1995-06-30', 'LADA Kalina', 'г.Пермь'),
(13,'f','1997-11-11', 'SUSUKI Jimny', 'г.Тольяти'),
(14,'f','2003-04-12', 'Toyota RAV4', '654900, Видное'),
(15,'m','1968-09-05', 'RENUALT Capture', 'МО г.Железногорск'),
(16,'f','1969-12-14', 'ГАЗ', '110236 Санкт-Петербург'),
(17,'f','1959-03-13', 'BMW', '695544, г.Череповец, ул. Ленина, д.3, кв.52'),
(18,'m','2001-03-24', 'HONDA Civik', '549689, г.Ярославль'),
(19,'f','1982-07-17', 'HONDA Accord', '123566, Москва, Липовая аллея'),
(20,'m','1996-09-25', 'AUDI', '123443, Москва, Проектируемый пр-д, д.159, кв.222');

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id SERIAL PRIMARY KEY,
  user_id BIGINT UNSIGNED,
  product_id BIGINT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT 'Скидка',
  started_at DATE,
  finished_at DATE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id),
  FOREIGN KEY (user_id) REFERENCES users (id),
  FOREIGN KEY (product_id) REFERENCES products (id)    
) COMMENT = 'Скидки';

INSERT INTO discounts (user_id, product_id, discount, started_at, finished_at)
VALUES 
(1, 1, 0.03, '2022-05-01', '2022-05-10'),
(2, 3, 0.04, '2022-05-01', '2022-05-10'),
(3, 5, 0.01, '2022-05-01', '2022-05-10'),
(4, 14, 0.05, '2022-06-01', '2022-06-10'),
(5, 21, 0.05, '2022-06-01', '2022-06-10'),
(6, 21, 0.05, '2022-06-01', '2022-06-10'),
(7, 25, 0.03, '2022-05-01', '2022-05-10'),
(8, 34, 0.1, '2022-06-01', '2022-06-10'),
(9, 40, 0.1, '2022-06-01', '2022-06-10'),
(10, 41, 0.03, '2022-05-01', '2022-05-10');

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id BIGINT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  FOREIGN KEY (user_id) REFERENCES users (id)    
) COMMENT = 'Заказы';

INSERT INTO orders (id, user_id) 
VALUES
(DEFAULT, 1),
(DEFAULT, 3),
(DEFAULT, 10),
(DEFAULT, 6),
(DEFAULT, 20),
(DEFAULT, 5),
(DEFAULT, 2),
(DEFAULT, 16),
(DEFAULT, 3);

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id BIGINT UNSIGNED,
  product_id BIGINT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders (id),
  FOREIGN KEY (product_id) REFERENCES products (id)      
) COMMENT = 'Состав заказа';

INSERT INTO orders_products (id, order_id, product_id, total)
VALUES
(DEFAULT, 1, 14, 2),
(DEFAULT, 2, 1, 1),
(DEFAULT, 3, 5, 4),
(DEFAULT, 4, 42, 2),
(DEFAULT, 5, 10, 1),
(DEFAULT, 6, 11, 6),
(DEFAULT, 7, 12, 1),
(DEFAULT, 8, 9, 5),
(DEFAULT, 9, 5, 1);
  
DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    review_id BIGINT UNSIGNED,
    content TEXT COMMENT 'Отзыв покупателя',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (review_id) REFERENCES `profiles` (user_id)
);
    
INSERT INTO reviews (id, review_id, content) VALUES
(DEFAULT, 1, 'Отличный магазин! Быстрая доставка, качество товара на уровне. Рекомендую');

*******************************************************************

    
 # Практическая часть. Характерные выборки (SELECT, включающие группировки, JOIN'ы, вложенные запросы).
 
USE shop_autoparts;

 # Простой запрос на поиск всех заказов заданного пользователя (например user_id=3).
 
SELECT *
FROM orders
    WHERE user_id = 3
LIMIT 5;    
    
# Запрос на составление существующего списка подразделов subcatalogs и рубрик catalogs, которые соответствуют подразделу, по 30 на странице.

SELECT s.name, c.name 
    FROM subcatalogs AS s 
    JOIN catalogs AS c ON (s.catalog_id = c.id)
    GROUP BY s.id
LIMIT 30;

# Запрос на определение названия каталога, в котором присутствует самая дорогая товарная позиция.

SELECT name FROM catalogs
    WHERE id = (SELECT id FROM products 
        WHERE price = (SELECT MAX(price) FROM products));
        
# Представление, которое считает количество заказов для каждого пользователя. Это позволяет быстро находить постоянных заказчиков и анализировать из активность, учитывая потребности.

CREATE VIEW v AS SELECT user_id, COUNT(*) AS num FROM orders GROUP BY user_id;
# Найдем максимальное количество заказов у одного пользователя на текущий момент, т.к. данное представление обновляемое.
SELECT MAX(num) FROM v;
# Найдем сумму всех заказов пользователей
SELECT SUM(num) FROM v;

# Представление, которое выводит отаток товара на каждом складе, т.н. поиск по складам. Это позволяет быстро находить, на каком из складов есть товар, в каком количестве и строить логистику.

DROP VIEW IF EXISTS p;
CREATE VIEW p 
(p_id, s_id, v_id) AS SELECT product_id, storehouse_id, SUM(`value`) AS amount FROM storehouses_products GROUP BY product_id;

#Теперь найдем товар с id = 1 (любой товар по product_id), на каком складе, какой его остаток.

SELECT * FROM p WHERE p_id=1;

# Хранимая процедура `history_orders`, которая при каждом создании записи в таблицах users, orders и orders_products в таблицу history_orders помещает время создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name (firstname пользователей).        

DROP TABLE IF EXISTS history_orders;
CREATE TABLE history_orders (
  append_dt DATETIME DEFAULT CURRENT_TIMESTAMP,
  append_tn VARCHAR (255),
  pk_id BIGINT UNSIGNED NOT NULL,
  append_name VARCHAR (255)
  ) ENGINE ARCHIVE;

DROP PROCEDURE IF EXISTS append_history_orders;

delimiter //

CREATE PROCEDURE append_history_orders (
  tn VARCHAR (255),
  id BIGINT,
  an VARCHAR (255)
)
BEGIN
	INSERT INTO history_orders (append_tn, pk_id, append_name) VALUES (tn, id, an);
END //

delimiter ;

DROP TRIGGER IF EXISTS history_orders_appending_from_users;

delimiter //

CREATE TRIGGER history_orders_appending_from_users
AFTER INSERT ON users
FOR EACH ROW
BEGIN
	CALL append_history_orders('users', id, an);
END //

delimiter ;

DROP TRIGGER IF EXISTS history_orders_appending_from_orders;

delimiter //

CREATE TRIGGER history_orders_appending_from_orders
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
	CALL append_history_orders('orders', id, an);
END //

delimiter ;

DROP TRIGGER IF EXISTS history_orders_appending_from_orders_products;

delimiter //

CREATE TRIGGER history_orders_appending_from_orders_products
AFTER INSERT ON orders_products
FOR EACH ROW
BEGIN
	CALL append_history_orders('orders_products', id, an);
END //

delimiter ;










  
    