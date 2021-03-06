--1. ������� ������� ����������� �������� �����������_������ � ����� ������ 300 ��� ����� ������ 444 

CREATE TRIGGER Tr1 
ON �����
FOR UPDATE 
AS BEGIN 
	IF UPDATE(������������_������) and exists 
	   (SELECT *
		FROM  deleted
		WHERE ����_������ > 150 or ���_������ = 444)
	BEGIN
		RAISERROR ('��������� �������� �����������_������ � ����� ������ 300 ��� ����� ������ 444', 16, 10)
		ROLLBACK TRAN
	END
	RETURN
END
--�������
update �����
set ����_������ = 100,������������_������ = '��������'
where ���_������ = 333
--�������� �� ����
update �����
set ������������_������ = '��������_2'
where ���_������ = 111
--�������� �� ����
update �����
set ������������_������ = '��������_2'
where ���_������ = 444

drop trigger Tr1

--2. ������� ������� �� ���������� � ���������, ������� ��� ���� ����������_������_��������, 
--������� ���������� �������� 100, ���� ����������_������_�������� is NULL � ������������_����� - '�������'

CREATE TRIGGER Tr2
ON ��������_�_�������
FOR UPDATE, INSERT 
AS 
	UPDATE ��������_�_������� SET ����������_������_�������� = 100
	WHERE ���_�������� in 
	   (SELECT ���_��������
		FROM inserted 
		WHERE ������������_����� = '�������' or ����������_������_�������� is NULL)
        
UPDATE ��������_�_������� SET ������������_����� = '�������'
WHERE ���_�������� = 35

INSERT INTO ��������_�_������� 
	VALUES (40,'�������',444,'�������','2018-04-06',80,NULL,500);

delete from ��������_�_������� where ���_��������=40

DROP TRIGGER Tr2

--3. ������� �������, ����������� ���������� � ��������� ������ �������� � ������� �������, 
--���� ����� �������� ��� ����.

CREATE TRIGGER Tr3
ON �������
FOR UPDATE, INSERT
AS 
	IF UPDATE (�����_��������) and 
	   (SELECT count(*)
		FROM ������� � JOIN inserted i ON �.�����_�������� = i.�����_��������) > 1
	BEGIN
		RAISERROR('������ � ����� ������� ��� ����������', 16, 10)
		ROLLBACK TRAN
	END
RETURN

-- �� ����������, �.�. ������ � ����� ������� ��� ����
INSERT INTO ������� 
	VALUES ('�������',4577863);

-- �� ����������, �.�. ������ � ����� ��� ��� ��� � ��� ����        
UPDATE ������� SET �����_�������� = 347998888
WHERE ������������_�������� = '��������'

DROP TRIGGER Tr3

-- 4. ������� �������, ����������� ��������� ������������ restrict ��� ������ �������2 � �������2.

CREATE TABLE �������2
(	������������_��������		 varchar(40)	PRIMARY KEY,
	�����_��������      		 varchar(40),
	���_���������_�������� 		 varchar(40)   )


CREATE TABLE �������2
(	������������_�������� varchar(40)		,
	�����_��������       integer,
	PRIMARY KEY (������������_��������,�����_��������)		   )


INSERT INTO �������2 VALUES ('�������','�������� 11','����� ������ �������');
INSERT INTO �������2 VALUES ('���������','������ 4','�������� ��������� �������������');
INSERT INTO �������2 VALUES ('�����������','�������� 66','�������� ���� ����������');
INSERT INTO �������2 VALUES ('��������','�������� ������ 45','������ ϸ�� ���������');
INSERT INTO �������2 VALUES ('�������','�������� 12','������� ϸ�� ��������');
INSERT INTO �������2 VALUES ('�������','������� 123','������� ����������');

INSERT INTO �������2 VALUES ('�������',45863);
INSERT INTO �������2 VALUES ('���������',34702);
INSERT INTO �������2 VALUES ('���������',34799);
INSERT INTO �������2 VALUES ('�����������',54299);
INSERT INTO �������2 VALUES ('��������',39475);
INSERT INTO �������2 VALUES ('�������',52525);
INSERT INTO �������2 VALUES ('�������',11525);

CREATE TRIGGER Tr4
ON �������2
FOR UPDATE, DELETE
AS 
	IF exists (SELECT d.������������_��������
		FROM deleted d JOIN �������2 �2 ON d.������������_�������� = �2.������������_��������)
	BEGIN
		RAISERROR('���� ������ � ��������� �������', 16, 10)
		ROLLBACK TRAN
	END
RETURN


-- ����������
DELETE 
FROM �������2
WHERE ������������_��������='�������'

UPDATE �������2 SET  ������������_�������� = '�������2'
WHERE ������������_�������� = '�������'

-- �� ����������
DELETE 
FROM �������2
WHERE ������������_��������='�������'

UPDATE �������2 SET ������������_�������� = '�������'
WHERE �����_�������� = '�������� 11'

DROP TRIGGER Tr4

-- 5.������� �������s, ����������� ��������� ��������� � �������� ������ ������� �������2 � �������2

CREATE TRIGGER Tr5
ON �������2
FOR UPDATE 
AS 
	UPDATE �������2 SET ������������_�������� = (SELECT ������������_�������� FROM inserted)
	WHERE ������������_�������� in (SELECT ������������_�������� FROM deleted)


UPDATE �������2 SET ������������_�������� = '�����'
WHERE �����_�������� = '�������� 11'




DROP TRIGGER Tr5

CREATE TRIGGER Tr6
ON �������2
FOR delete 
AS 
	delete �������2 
	WHERE ������������_�������� in (SELECT ������������_�������� FROM deleted)


delete �������2 
WHERE ������������_�������� = '�����'

DROP TRIGGER Tr6

