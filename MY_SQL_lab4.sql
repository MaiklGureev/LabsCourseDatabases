--1. Создать и вызвать хранимую процедуру, которая увеличит цену товара на 20. 
--Произвести проверку на наличие товара в базе данных. Цену изменять с помощью курсора.

CREATE PROCEDURE Pr_1
AS BEGIN 
   DECLARE @col INT
   SET @col = (SELECT COUNT(*) FROM Товар)
   IF @col > 0 BEGIN
      DECLARE cur1 CURSOR DYNAMIC SCROLL
      FOR SELECT Код_товара, Наименование_товара
      FROM Товар
	  OPEN cur1
	  FETCH FIRST FROM cur1 
      WHILE @@FETCH_STATUS=0 BEGIN
	    UPDATE Товар SET Цена_товара = Цена_товара + 20
		WHERE current of cur1
        FETCH NEXT FROM cur1 
      END
	  CLOSE cur1
      DEALLOCATE cur1
   END
END

EXEC Pr_1
select* from Товар

drop procedure Pr_1

--2.Создать и вызвать хранимую процедуру, которая вернет количество номеров, у данного Магазина и 
--в диапазоне номеров больше заданного. 
--Наименование магазина и номер телефона передавать в качестве параметров процедуры.

CREATE PROCEDURE Pr_2
@name_m varchar(25), --входной
@col int OUTPUT, --выходной
@num_tel int = 34000 -- по-умолчанию
AS BEGIN
   SELECT @col = COUNT(М.Наименование_магазина)
   FROM Магазин М
   JOIN  Телефон т 
   ON М.Наименование_магазина = Т.Наименование_магазина
   WHERE Т.Номер_телефона > @num_tel AND М.Наименование_магазина = @name_m
END
--позиционный
DECLARE @col int
EXEC Pr_2 'Столичный',  @col OUTPUT
SELECT @col
--ключевой
declare @col1 int
exec Pr_2 @name_m = 'Столичный', @col=@col1 output
select [Количество_номеров]=@col1


DROP PROCEDURE Pr_2

--3. Создать и вызвать хранимую процедуру, возвращаущую курсор, 
--содержащий список магазинов, которым постовляет заданный поставщик. 
--Наименоваи магазина передавать как параметр поцедуры.

CREATE PROCEDURE Pr_3
@name_p varchar(25),
@result CURSOR VARYING OUTPUT
AS BEGIN
   SET @result = CURSOR SCROLL STATIC
   FOR SELECT DISTINCT(м.Наименование_магазина)
   FROM  Магазин м
   JOIN Поставка_в_магазин пм ON пм.Наименование_магазина = м.Наименование_магазина 
   JOIN Фирма ф ON ф.Наименование_фирмы = пм.Наименование_фирмы
   WHERE ф.Наименование_фирмы = @name_p
   OPEN @result
   RETURN
END

DECLARE @cur CURSOR
EXEC Pr_3 'Победа', @cur OUTPUT
FETCH FIRST FROM @cur
WHILE @@FETCH_STATUS = 0
FETCH NEXT FROM @cur

DROP PROCEDURE Pr_3

--4. Создать и запустить хранимую функцию, которая по номеру поставки возвратит кол во номеров телефонов, у магазина.

CREATE FUNCTION  Fun_1 (@cod_post int)
RETURNS INT
AS BEGIN
   DECLARE @col INT
   SET @col = (SELECT COUNT(т.Номер_телефона)
               FROM  Телефон т
			   JOIN Магазин м ON м.Наименование_магазина = т.Наименование_магазина
               JOIN Поставка_в_магазин пм ON пм.Наименование_магазина = м.Наименование_магазина
			   WHERE пм.Код_поставки = @cod_post)
   RETURN @col
END

SELECT dbo.Fun_1(33)
AS Количество_номеров

DROP FUNCTION Fun_1

--5.Создать и запустить хранимую функцию, которая по коду поставки вернет вернет список номеров телефонов магазина.

CREATE FUNCTION Fun_2 (@cod_post int)
RETURNS TABLE
AS
  RETURN (SELECT DISTINCT(т.Номер_телефона)
		  AS Номера_телефонов_магазина
          FROM Поставка_в_магазин пм
		  JOIN Магазин м ON м.Наименование_магазина = пм.Наименование_магазина
          JOIN Телефон т ON м.Наименование_магазина = т.Наименование_магазина
		  WHERE пм.Код_поставки = @cod_post)

SELECT * FROM dbo.Fun_2(33)


DROP FUNCTION Fun_2
