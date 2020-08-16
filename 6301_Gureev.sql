
CREATE TABLE Магазин
( 
	Наименование_магазина		 varchar(40)	PRIMARY KEY,
	Адрес_магазина      		 varchar(40),
	ФИО_директора_магазина 		 varchar(40)   
)
go


CREATE TABLE Фирма
( 
	Наименование_фирмы		 varchar(40)	PRIMARY KEY,
	Телефон      		 	 varchar(40),
	ФИО_директора_фирмы 	 varchar(40)   
)
go


CREATE TABLE Телефон
( 
	Наименование_магазина varchar(40)		REFERENCES	Магазин	(Наименование_магазина),
	Номер_телефона       integer,
	PRIMARY KEY (Наименование_магазина,Номер_телефона)		   
)
go



CREATE TABLE Товар
( 
	Код_товара           integer 	PRIMARY KEY,
	Наименование_товара  varchar(40),
	Цена_товара          integer   
)
go



CREATE TABLE Диапазон_скидок
( 
	id_скидки            integer	Primary key,
	диапазон_от          integer,
	диапазон_до          integer  
)
go



CREATE TABLE Товар_склада
(
	Код_товара			integer			REFERENCES	Товар(Код_товара),
	Дата_поступления	datetime	,
	PRIMARY KEY (Код_товара,Дата_поступления),
	Количество_товара_на_складе	integer,
	id_скидки			integer			REFERENCES	Диапазон_скидок(id_скидки)
)
go



CREATE TABLE Поставка_в_магазин
( 
	Код_поставки         integer	PRIMARY KEY,
	Наименование_магазина varchar(40)		REFERENCES	Магазин	(Наименование_магазина),
	Код_товара           integer	,		 	
	Наименование_фирмы   varchar(40)		REFERENCES	Фирма(Наименование_фирмы),
	Дата_поступления     datetime	,			
	Количество_товара_на_складе    integer,
	Количество_товара_поставки   integer,
	Цена_поставки        integer,   
	FOREIGN KEY (Код_товара, Дата_поступления) REFERENCES Товар_склада(Код_товара, Дата_поступления),
	UNIQUE (Наименование_магазина,Наименование_фирмы,Дата_поступления, Код_товара,Количество_товара_поставки)
)
go



INSERT INTO Магазин VALUES ('Ветерок','Мичурина 11','Зимин Елисей Титович');
INSERT INTO Магазин VALUES ('Столичный','Ленина 4','Ульянова Екатерина Александровна');
INSERT INTO Магазин VALUES ('Продуктовый','Мичурина 66','Кузнецов Семён Васильевич');
INSERT INTO Магазин VALUES ('Пятёрочка','проспект Победы 45','Иванов Пётр Сергеевич');
INSERT INTO Магазин VALUES ('Колосок','Мичурина 12','Кузьмин Пётр Иванович');

INSERT INTO Фирма VALUES ('Победа',24533,'Шурша Юнона Александровна');
INSERT INTO Фирма VALUES ('Армата',26543,'Малахов Степан Давыдович');
INSERT INTO Фирма VALUES ('Буран',80301,'Хлебников Павел Капитонович');
INSERT INTO Фирма VALUES ('Торпеда',25432,'Статник Ираклий Герасимович');
INSERT INTO Фирма VALUES ('Ракета',325692,'Павлов Борис Викторович');
INSERT INTO Фирма VALUES ('NULL',00000,'NULL');
INSERT INTO Фирма VALUES ('NULL2',11111,'NULL2');

INSERT INTO Телефон VALUES ('Ветерок',45863);
INSERT INTO Телефон VALUES ('Столичный',34702);
INSERT INTO Телефон VALUES ('Столичный',34799);
INSERT INTO Телефон VALUES ('Продуктовый',54299);
INSERT INTO Телефон VALUES ('Пятёрочка',39475);
INSERT INTO Телефон VALUES ('Колосок',52525);
INSERT INTO Телефон VALUES ('Колосок',11525);


INSERT INTO Товар VALUES (111,'Масло сливочное',150);
INSERT INTO Товар VALUES (222,'Хлеб пшеничный',100);
INSERT INTO Товар VALUES (333,'Молоко',200);
INSERT INTO Товар VALUES (444,'Окорочка',500);
INSERT INTO Товар VALUES (555,'Яблоки',50);

INSERT INTO Диапазон_скидок VALUES (01,4,7);
INSERT INTO Диапазон_скидок VALUES (02,5,9);
INSERT INTO Диапазон_скидок VALUES (03,2,4);
INSERT INTO Диапазон_скидок VALUES (04,1,7);
INSERT INTO Диапазон_скидок VALUES (05,3,10);
INSERT INTO Диапазон_скидок VALUES (06,99,100);
INSERT INTO Диапазон_скидок VALUES (07,50,100);

INSERT INTO Товар_склада VALUES (111,'2017-04-12',50,01);
INSERT INTO Товар_склада VALUES (222,'2018-04-9',90,02);
INSERT INTO Товар_склада VALUES (333,'2017-07-12',30,03);
INSERT INTO Товар_склада VALUES (444,'2018-04-06',80,04);
INSERT INTO Товар_склада VALUES (555,'2018-04-02',70,05);


INSERT INTO Поставка_в_магазин VALUES (32,'Ветерок',111,'Победа','2017-04-12',50,10,150);
INSERT INTO Поставка_в_магазин VALUES (33,'Столичный',222,'Армата','2018-04-09',90,20,100);
INSERT INTO Поставка_в_магазин VALUES (34,'Продуктовый',333,'Буран','2017-07-12',30,15,200);
INSERT INTO Поставка_в_магазин VALUES (35,'Пятёрочка',444,'Торпеда','2018-04-06',80,40,500);
INSERT INTO Поставка_в_магазин VALUES (36,'Колосок',555,'Ракета','2018-04-02',70,20,120);