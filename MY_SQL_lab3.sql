--1.1
DECLARE stkr CURSOR SCROLL STATIC 
FOR SELECT ���_��������, ������������_��������, ������������_�����, ����_��������
FROM ��������_�_�������

OPEN stkr

DECLARE @���_���� varchar(25);
DECLARE @������������_� varchar(25);
DECLARE @������������_� varchar(25);
DECLARE @����_���� INTEGER;
FETCH FIRST FROM stkr INTO @���_����, @������������_�, @������������_�, @����_����
WHILE @@FETCH_STATUS=0
BEGIN
SELECT  [���_��������] = @���_����,
		[������������_��������] = @������������_�,
		[������������_�����] = @������������_�,
		[����_��������] = @����_����
FETCH NEXT FROM stkr INTO @���_����, @������������_�, @������������_�, @����_����
END

update ��������_�_�������
set ������������_��������='�������'
where ���_��������=33

CLOSE stkr
DEALLOCATE stkr

go

--1.2
DECLARE dnkr CURSOR SCROLL DYNAMIC	
FOR SELECT ���_��������, ������������_��������, ������������_�����, ����_��������
FROM ��������_�_�������

OPEN dnkr

DECLARE @���_���� varchar(25);
DECLARE @������������_� varchar(25);
DECLARE @������������_� varchar(25);
DECLARE @����_���� INTEGER;
FETCH FIRST FROM dnkr INTO @���_����, @������������_�, @������������_�, @����_����
WHILE @@FETCH_STATUS=0
BEGIN
SELECT  [���_��������] = @���_����,
		[������������_��������] = @������������_�,
		[������������_�����] = @������������_�,
		[����_��������] = @����_����
FETCH NEXT FROM dnkr INTO @���_����, @������������_�, @������������_�, @����_����
END

CLOSE dnkr
DEALLOCATE dnkr

go

update ��������_�_�������
set ������������_��������='��������'
where ���_��������=33

--1.3
DECLARE keykr CURSOR SCROLL KEYSET	
FOR SELECT ���_��������, ������������_��������, ������������_�����, ����_��������
FROM ��������_�_�������

OPEN keykr

DECLARE @���_���� varchar(25);
DECLARE @������������_� varchar(25);
DECLARE @������������_� varchar(25);
DECLARE @����_���� INTEGER;
FETCH FIRST FROM keykr INTO @���_����, @������������_�, @������������_�, @����_����
WHILE @@FETCH_STATUS=0
BEGIN
SELECT [���_��������] = @���_����,
		[������������_��������] = @������������_�,
		[������������_�����] = @������������_�,
		[����_��������] = @����_����
FETCH NEXT FROM keykr INTO @���_����, @������������_�, @������������_�, @����_����
END

CLOSE keykr
DEALLOCATE keykr

update ��������_�_�������
set ���_��������=40
where ���_��������=35

--2.1 ���������
FETCH first FROM dnkr 
WHILE @@FETCH_STATUS=0
BEGIN
UPDATE ��������_�_�������
SET ����_�������� = 0
WHERE CURRENT OF dnkr
FETCH NEXT FROM dnkr 
END


--2.2 ��������
FETCH first FROM dnkr
DELETE FROM ��������_�_�������
WHERE CURRENT OF dnkr

--3. ������� ���������������� ���, ������� ��� � ����� �������. ��������� ����������� ���� ��� ���������� ������. 
CREATE TYPE newType
FROM varchar(30) NOT NULL ;  

CREATE TABLE �������2
( 
	������������_��������		 varchar(20)	PRIMARY KEY,
	�����_��������      		 varchar(20),
	���_���������_�������� 		 newType   
);

INSERT INTO �������2
			VALUES ('������_���','������ 22','������ ������ �������');
INSERT INTO �������2 
			VALUES ('�����','������ 4',NULL); --������ 
 
DROP TABLE �������2
DROP TYPE newType

--4. ������� 2 �������, ���� ������� � ���������������� �����, ������ �� �������� �������. ��������� �������� ��� ���������� � ��������� �������. 
CREATE TYPE newType2
FROM  integer NOT NULL

CREATE TABLE �����2
( 
	���_������           integer 	PRIMARY KEY,
	������������_������  varchar(40),
	����_������          newType2   
); 

CREATE RULE �������_���_������
AS @���_������ <= 105

sp_bindrule �������_���_������, newType2

CREATE RULE �������_����_������ 
AS @����_������ <= 200

sp_bindrule �������_����_������, '�����2.���_������'

INSERT INTO �����2 VALUES (101,'����� ���������',500);--������ 
INSERT INTO �����2 VALUES (101,'����� ���������',150);

INSERT INTO �����2 VALUES (9999,'���� ���������',50);--������ 
INSERT INTO �����2 VALUES (100,'���� ���������',100);

UPDATE �����2
SET ���_������ = 333
WHERE ������������_������ = '����� ���������'

UPDATE �����2
SET ����_������ = 500
WHERE ������������_������ = '���� ���������'

sp_unbindrule '�����2.����_������'

DROP TABLE �����2
DROP TYPE newType2
drop rule �������_����_������
drop rule �������_���_������

--5. ������� �������� �� ���������, ������� � �����. ��������� ��������.
CREATE TABLE �����2
( 
	���_������           integer 	PRIMARY KEY,
	������������_������  varchar(40),
	����_������          integer   
); 

CREATE DEFAULT ����_��_��������� AS 330

sp_bindefault ����_��_���������, '�����2.����_������'

INSERT INTO �����2 VALUES (110,'����',DEFAULT);

SELECT * FROM �����2
        
sp_unbindefault '�����2.����_������'
drop table �����2
drop default ����_��_���������

--6. ������� ������� ���, ��������� ���, ��� �� ����.
--6.1 ������� ���.
CREATE VIEW v_1 (���_������, ������������_������) AS
   SELECT �.���_������, �.������������_������
   FROM ����� �
   
SELECT *
FROM v_1

drop view v_1

--6.2 ��������� ���
CREATE VIEW v_2 (���_������, ������������_������, ����������_������_��_������) AS
   SELECT �.���_������, �.������������_������, ��.����������_������_��_������
   FROM ����� � 
   JOIN �����_������ �� 
   ON �.���_������ = ��.���_������

SELECT *
FROM v_2
order by ���_������

drop view v_2

--6.3 ��� �� ����  
CREATE VIEW v_3 (������������_������) AS
   SELECT ������������_������
   FROM v_2
   UNION
   SELECT ������������_������
   FROM v_1

SELECT *
FROM v_3

drop view v_3

--7. ������� ��� � ����������� ������� ��������. ��������� �������� ������ �� ���� � ��������� ����� ����.
CREATE VIEW v_4 (�������1, �������2) AS
SELECT ���_������, ������������_������
FROM ����� �

SELECT �������1, �������1
FROM v_4

drop view v_4

--8. ������� ������� ��� � ������ WITH CHECK OPTION � ��� ���. ��������� �������� ����� ��� ���������� � ��������� ������� ����� ���,
--��������������� � �� ��������������� ������� ����.
CREATE VIEW v_5 (���, ������������, ����) AS
SELECT ���_������, ������������_������, ����_������
FROM �����
WHERE ����_������ < 300

CREATE VIEW v_6 (���, ������������, ����) AS
SELECT ���_������, ������������_������, ����_������
FROM �����
WHERE ����_������ < 300  WITH CHECK OPTION

--��� ���-� ����� �� �����-��
UPDATE v_5
SET ���� = 999 
WHERE ��� = 111

UPDATE v_6
SET ���� = 999 
WHERE ��� = 222

select* from v_6

--��� ���-� v_5 ��� ������, v_6 � �������
INSERT INTO v_5 
	VALUES (55,'���� ���������',9900);

INSERT INTO v_6 
    VALUES (56,'���� ��������� ��������',9999)

drop view v_5
drop view v_6
