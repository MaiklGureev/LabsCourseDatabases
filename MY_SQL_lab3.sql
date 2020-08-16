--1.1
DECLARE stkr CURSOR SCROLL STATIC 
FOR SELECT Код_поставки, Наименование_магазина, Наименование_фирмы, Цена_поставки
FROM Поставка_в_магазин

OPEN stkr

DECLARE @Код_пост varchar(25);
DECLARE @Наименование_м varchar(25);
DECLARE @Наименование_ф varchar(25);
DECLARE @Цена_пост INTEGER;
FETCH FIRST FROM stkr INTO @Код_пост, @Наименование_м, @Наименование_ф, @Цена_пост
WHILE @@FETCH_STATUS=0
BEGIN
SELECT  [Код_поставки] = @Код_пост,
		[Наименование_магазина] = @Наименование_м,
		[Наименование_фирмы] = @Наименование_ф,
		[Цена_поставки] = @Цена_пост
FETCH NEXT FROM stkr INTO @Код_пост, @Наименование_м, @Наименование_ф, @Цена_пост
END

update Поставка_в_магазин
set Наименование_магазина='Колосок'
where Код_поставки=33

CLOSE stkr
DEALLOCATE stkr

go

--1.2
DECLARE dnkr CURSOR SCROLL DYNAMIC	
FOR SELECT Код_поставки, Наименование_магазина, Наименование_фирмы, Цена_поставки
FROM Поставка_в_магазин

OPEN dnkr

DECLARE @Код_пост varchar(25);
DECLARE @Наименование_м varchar(25);
DECLARE @Наименование_ф varchar(25);
DECLARE @Цена_пост INTEGER;
FETCH FIRST FROM dnkr INTO @Код_пост, @Наименование_м, @Наименование_ф, @Цена_пост
WHILE @@FETCH_STATUS=0
BEGIN
SELECT  [Код_поставки] = @Код_пост,
		[Наименование_магазина] = @Наименование_м,
		[Наименование_фирмы] = @Наименование_ф,
		[Цена_поставки] = @Цена_пост
FETCH NEXT FROM dnkr INTO @Код_пост, @Наименование_м, @Наименование_ф, @Цена_пост
END

CLOSE dnkr
DEALLOCATE dnkr

go

update Поставка_в_магазин
set Наименование_магазина='Пятёрочка'
where Код_поставки=33

--1.3
DECLARE keykr CURSOR SCROLL KEYSET	
FOR SELECT Код_поставки, Наименование_магазина, Наименование_фирмы, Цена_поставки
FROM Поставка_в_магазин

OPEN keykr

DECLARE @Код_пост varchar(25);
DECLARE @Наименование_м varchar(25);
DECLARE @Наименование_ф varchar(25);
DECLARE @Цена_пост INTEGER;
FETCH FIRST FROM keykr INTO @Код_пост, @Наименование_м, @Наименование_ф, @Цена_пост
WHILE @@FETCH_STATUS=0
BEGIN
SELECT [Код_поставки] = @Код_пост,
		[Наименование_магазина] = @Наименование_м,
		[Наименование_фирмы] = @Наименование_ф,
		[Цена_поставки] = @Цена_пост
FETCH NEXT FROM keykr INTO @Код_пост, @Наименование_м, @Наименование_ф, @Цена_пост
END

CLOSE keykr
DEALLOCATE keykr

update Поставка_в_магазин
set Код_поставки=40
where Код_поставки=35

--2.1 Изменение
FETCH first FROM dnkr 
WHILE @@FETCH_STATUS=0
BEGIN
UPDATE Поставка_в_магазин
SET Цена_поставки = 0
WHERE CURRENT OF dnkr
FETCH NEXT FROM dnkr 
END


--2.2 Удаление
FETCH first FROM dnkr
DELETE FROM Поставка_в_магазин
WHERE CURRENT OF dnkr

--3. Создать пользовательский тип, связать его с полем таблицы. Проверить ограничение типа при добавлении записи. 
CREATE TYPE newType
FROM varchar(30) NOT NULL ;  

CREATE TABLE Магазин2
( 
	Наименование_магазина		 varchar(20)	PRIMARY KEY,
	Адрес_магазина      		 varchar(20),
	ФИО_директора_магазина 		 newType   
);

INSERT INTO Магазин2
			VALUES ('АВРОРА_МОЛ','Аврора 22','Крутой Кирилл Титович');
INSERT INTO Магазин2 
			VALUES ('ДИКСИ','Ленина 4',NULL); --ошибка 
 
DROP TABLE Магазин2
DROP TYPE newType

--4. Создать 2 правила, одно связать с пользовательским типом, другое со столбцом таблицы. Проверить действие при добавлении и изменении записей. 
CREATE TYPE newType2
FROM  integer NOT NULL

CREATE TABLE Товар2
( 
	Код_товара           integer 	PRIMARY KEY,
	Наименование_товара  varchar(40),
	Цена_товара          newType2   
); 

CREATE RULE Правило_код_товара
AS @Код_товара <= 105

sp_bindrule Правило_код_товара, newType2

CREATE RULE Правило_цена_товара 
AS @Цена_товара <= 200

sp_bindrule Правило_цена_товара, 'Товар2.Код_товара'

INSERT INTO Товар2 VALUES (101,'Масло сливочное',500);--ошибка 
INSERT INTO Товар2 VALUES (101,'Масло сливочное',150);

INSERT INTO Товар2 VALUES (9999,'Хлеб пшеничный',50);--ошибка 
INSERT INTO Товар2 VALUES (100,'Хлеб пшеничный',100);

UPDATE Товар2
SET Код_товара = 333
WHERE Наименование_товара = 'Масло сливочное'

UPDATE Товар2
SET Цена_товара = 500
WHERE Наименование_товара = 'Хлеб пшеничный'

sp_unbindrule 'Товар2.Цена_товара'

DROP TABLE Товар2
DROP TYPE newType2
drop rule Правило_цена_товара
drop rule Правило_код_товара

--5. Создать значение по умолчанию, связать с полем. Проверить действие.
CREATE TABLE Товар2
( 
	Код_товара           integer 	PRIMARY KEY,
	Наименование_товара  varchar(40),
	Цена_товара          integer   
); 

CREATE DEFAULT Цена_по_умолчанию AS 330

sp_bindefault Цена_по_умолчанию, 'Товар2.Цена_товара'

INSERT INTO Товар2 VALUES (110,'Хлеб',DEFAULT);

SELECT * FROM Товар2
        
sp_unbindefault 'Товар2.Цена_товара'
drop table Товар2
drop default Цена_по_умолчанию

--6. Создать простой вид, составной вид, вид из вида.
--6.1 Простой вид.
CREATE VIEW v_1 (Код_товара, Наименование_товара) AS
   SELECT Т.Код_товара, Т.Наименование_товара
   FROM Товар Т
   
SELECT *
FROM v_1

drop view v_1

--6.2 Составной вид
CREATE VIEW v_2 (Код_товара, Наименование_товара, Количество_товара_на_складе) AS
   SELECT Т.Код_товара, Т.Наименование_товара, ТС.Количество_товара_на_складе
   FROM Товар Т 
   JOIN Товар_склада ТС 
   ON Т.Код_товара = ТС.Код_товара

SELECT *
FROM v_2
order by Код_товара

drop view v_2

--6.3 Вид из вида  
CREATE VIEW v_3 (Наименование_товара) AS
   SELECT Наименование_товара
   FROM v_2
   UNION
   SELECT Наименование_товара
   FROM v_1

SELECT *
FROM v_3

drop view v_3

--7. Создать вид с измененными именами столбцов. Выполнить просмотр данных из вида с указанием новых имен.
CREATE VIEW v_4 (Столбец1, Столбец2) AS
SELECT Код_товара, Наименование_товара
FROM Товар Т

SELECT Столбец1, Столбец1
FROM v_4

drop view v_4

--8. Создать простой вид с опцией WITH CHECK OPTION и без нее. Проверить действие опции при добавлении и изменении записей через вид,
--удовлетворяющих и не удовлетворяющих условий вида.
CREATE VIEW v_5 (Код, Наименование, Цена) AS
SELECT Код_товара, Наименование_товара, Цена_товара
FROM Товар
WHERE Цена_товара < 300

CREATE VIEW v_6 (Код, Наименование, Цена) AS
SELECT Код_товара, Наименование_товара, Цена_товара
FROM Товар
WHERE Цена_товара < 300  WITH CHECK OPTION

--при изм-и ничем не отлич-ся
UPDATE v_5
SET Цена = 999 
WHERE Код = 111

UPDATE v_6
SET Цена = 999 
WHERE Код = 222

select* from v_6

--при доб-и v_5 без ошибки, v_6 с ошибкой
INSERT INTO v_5 
	VALUES (55,'Хлеб пшеничный',9900);

INSERT INTO v_6 
    VALUES (56,'Хлеб пшеничный отборный',9999)

drop view v_5
drop view v_6
