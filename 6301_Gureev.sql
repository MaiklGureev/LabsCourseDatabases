
CREATE TABLE �������
( 
	������������_��������		 varchar(40)	PRIMARY KEY,
	�����_��������      		 varchar(40),
	���_���������_�������� 		 varchar(40)   
)
go


CREATE TABLE �����
( 
	������������_�����		 varchar(40)	PRIMARY KEY,
	�������      		 	 varchar(40),
	���_���������_����� 	 varchar(40)   
)
go


CREATE TABLE �������
( 
	������������_�������� varchar(40)		REFERENCES	�������	(������������_��������),
	�����_��������       integer,
	PRIMARY KEY (������������_��������,�����_��������)		   
)
go



CREATE TABLE �����
( 
	���_������           integer 	PRIMARY KEY,
	������������_������  varchar(40),
	����_������          integer   
)
go



CREATE TABLE ��������_������
( 
	id_������            integer	Primary key,
	��������_��          integer,
	��������_��          integer  
)
go



CREATE TABLE �����_������
(
	���_������			integer			REFERENCES	�����(���_������),
	����_�����������	datetime	,
	PRIMARY KEY (���_������,����_�����������),
	����������_������_��_������	integer,
	id_������			integer			REFERENCES	��������_������(id_������)
)
go



CREATE TABLE ��������_�_�������
( 
	���_��������         integer	PRIMARY KEY,
	������������_�������� varchar(40)		REFERENCES	�������	(������������_��������),
	���_������           integer	,		 	
	������������_�����   varchar(40)		REFERENCES	�����(������������_�����),
	����_�����������     datetime	,			
	����������_������_��_������    integer,
	����������_������_��������   integer,
	����_��������        integer,   
	FOREIGN KEY (���_������, ����_�����������) REFERENCES �����_������(���_������, ����_�����������),
	UNIQUE (������������_��������,������������_�����,����_�����������, ���_������,����������_������_��������)
)
go



INSERT INTO ������� VALUES ('�������','�������� 11','����� ������ �������');
INSERT INTO ������� VALUES ('���������','������ 4','�������� ��������� �������������');
INSERT INTO ������� VALUES ('�����������','�������� 66','�������� ���� ����������');
INSERT INTO ������� VALUES ('��������','�������� ������ 45','������ ϸ�� ���������');
INSERT INTO ������� VALUES ('�������','�������� 12','������� ϸ�� ��������');

INSERT INTO ����� VALUES ('������',24533,'����� ����� �������������');
INSERT INTO ����� VALUES ('������',26543,'������� ������ ���������');
INSERT INTO ����� VALUES ('�����',80301,'��������� ����� �����������');
INSERT INTO ����� VALUES ('�������',25432,'������� ������� �����������');
INSERT INTO ����� VALUES ('������',325692,'������ ����� ����������');
INSERT INTO ����� VALUES ('NULL',00000,'NULL');
INSERT INTO ����� VALUES ('NULL2',11111,'NULL2');

INSERT INTO ������� VALUES ('�������',45863);
INSERT INTO ������� VALUES ('���������',34702);
INSERT INTO ������� VALUES ('���������',34799);
INSERT INTO ������� VALUES ('�����������',54299);
INSERT INTO ������� VALUES ('��������',39475);
INSERT INTO ������� VALUES ('�������',52525);
INSERT INTO ������� VALUES ('�������',11525);


INSERT INTO ����� VALUES (111,'����� ���������',150);
INSERT INTO ����� VALUES (222,'���� ���������',100);
INSERT INTO ����� VALUES (333,'������',200);
INSERT INTO ����� VALUES (444,'��������',500);
INSERT INTO ����� VALUES (555,'������',50);

INSERT INTO ��������_������ VALUES (01,4,7);
INSERT INTO ��������_������ VALUES (02,5,9);
INSERT INTO ��������_������ VALUES (03,2,4);
INSERT INTO ��������_������ VALUES (04,1,7);
INSERT INTO ��������_������ VALUES (05,3,10);
INSERT INTO ��������_������ VALUES (06,99,100);
INSERT INTO ��������_������ VALUES (07,50,100);

INSERT INTO �����_������ VALUES (111,'2017-04-12',50,01);
INSERT INTO �����_������ VALUES (222,'2018-04-9',90,02);
INSERT INTO �����_������ VALUES (333,'2017-07-12',30,03);
INSERT INTO �����_������ VALUES (444,'2018-04-06',80,04);
INSERT INTO �����_������ VALUES (555,'2018-04-02',70,05);


INSERT INTO ��������_�_������� VALUES (32,'�������',111,'������','2017-04-12',50,10,150);
INSERT INTO ��������_�_������� VALUES (33,'���������',222,'������','2018-04-09',90,20,100);
INSERT INTO ��������_�_������� VALUES (34,'�����������',333,'�����','2017-07-12',30,15,200);
INSERT INTO ��������_�_������� VALUES (35,'��������',444,'�������','2018-04-06',80,40,500);
INSERT INTO ��������_�_������� VALUES (36,'�������',555,'������','2018-04-02',70,20,120);