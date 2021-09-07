USE [Arzybek]
GO

IF OBJECT_ID('Arzybek.����', 'U') IS NOT NULL
  DROP TABLE  Arzybek.����
GO

IF OBJECT_ID('Arzybek.�����', 'U') IS NOT NULL
  DROP TABLE  Arzybek.�����
GO

IF OBJECT_ID('Arzybek.�������', 'U') IS NOT NULL
  DROP TABLE  Arzybek.�������
GO

IF OBJECT_ID('Arzybek.�������', 'U') IS NOT NULL
  DROP TABLE  Arzybek.�������
GO

IF OBJECT_ID('Arzybek.��������', 'U') IS NOT NULL
  DROP TABLE  Arzybek.��������
GO

IF OBJECT_ID('Arzybek.AllGoals', 'U') IS NOT NULL
  DROP TABLE  Arzybek.AllGoals
GO

IF OBJECT_ID('Arzybek.FinalRepresentation', 'U') IS NOT NULL
  DROP TABLE  Arzybek.FinalRepresentation
GO

IF OBJECT_ID('Arzybek.FinalTemporary', 'U') IS NOT NULL
  DROP TABLE  Arzybek.FinalTemporary
GO

IF OBJECT_ID('Arzybek.GoalsAutoGoals', 'U') IS NOT NULL
  DROP TABLE  Arzybek.GoalsAutoGoals
GO

IF OBJECT_ID('Arzybek.T3Result', 'U') IS NOT NULL
  DROP TABLE  Arzybek.T3Result
GO

IF OBJECT_ID('Arzybek.T4Result', 'U') IS NOT NULL
  DROP TABLE  Arzybek.T4Result
GO

IF OBJECT_ID('Arzybek.Task2Result', 'U') IS NOT NULL
  DROP TABLE  Arzybek.Task2Result
GO

IF OBJECT_ID('Arzybek.TableTwoCommands', 'U') IS NOT NULL
  DROP TABLE  Arzybek.TableTwoCommands
GO

IF OBJECT_ID('Arzybek.TwoTeamsTwoScores', 'U') IS NOT NULL
  DROP TABLE  Arzybek.TwoTeamsTwoScores
GO

CREATE TABLE Arzybek.����
(
    Id_����� TinyInt NOT NULL,
	Id_������� TinyInt NOT NULL,
	���� bit NOT NULL,
    ��� VARCHAR(40) NOT NULL,
    ����� TIME NOT NULL,
    ������� TinyInt NOT NULL
)
GO

CREATE TABLE Arzybek.�����
(
    Id_����� TinyInt NOT NULL,
    Id_������� TinyInt NOT NULL,
    ���� DateTime NOT NULL,
    Id_�������� TinyInt NOT NULL,
    CONSTRAINT PK_����� PRIMARY KEY (Id_�����, Id_�������)
)
GO
 
CREATE TABLE Arzybek.�������
(
    ������ VARCHAR(40) NOT NULL,
    ������ CHAR(1) NOT NULL,  
    Id TinyInt NOT NULL
)
GO
 
CREATE TABLE Arzybek.��������
(
    Id_�������� TinyInt NOT NULL,
    �������� VARCHAR(40) NOT NULL,  
)
GO
 
CREATE TABLE Arzybek.�������
(
    �������� VARCHAR(40) NOT NULL,
    Id TinyInt NOT NULL,
)
GO
	
ALTER TABLE Arzybek.���� ADD
	CONSTRAINT PK_Goals PRIMARY KEY (Id_�����, Id_�������, �����) 
GO	

ALTER TABLE Arzybek.������� ADD
	CONSTRAINT PK_Team PRIMARY KEY (Id) 
GO		

ALTER TABLE Arzybek.�������� ADD
	CONSTRAINT PK_Stadium PRIMARY KEY (Id_��������) 
GO	

ALTER TABLE Arzybek.������� ADD
	CONSTRAINT PK_Pos PRIMARY KEY (Id) 
GO	

ALTER TABLE Arzybek.���� ADD
	CONSTRAINT FK_Goals FOREIGN KEY (Id_�����, Id_�������) 
	REFERENCES Arzybek.�����(Id_�����, Id_�������)
GO	

ALTER TABLE Arzybek.����� ADD
	CONSTRAINT FK_Team_1 FOREIGN KEY (Id_�������) 
	REFERENCES Arzybek.�������(Id)
GO		

ALTER TABLE Arzybek.����� ADD
	CONSTRAINT FK_Stadium FOREIGN KEY (Id_��������) 
	REFERENCES Arzybek.��������(Id_��������)
GO		

ALTER TABLE Arzybek.���� ADD
	CONSTRAINT FK_Pos FOREIGN KEY (�������) 
	REFERENCES Arzybek.�������(Id)
GO		   
 
INSERT INTO Arzybek.�������
(������, ������, Id)
 VALUES
 ('�������', 'A', 3),
 ('������','A' , 4)
 ,('������','A',2)
 ,('���������� ������','A',1)   ,
  ('������', 'F', 5),
 ('�������','F' , 6)
 ,('���������� �����','F', 7)
 ,('��������','F', 8)  
GO 
 
INSERT INTO Arzybek.��������
(Id_��������, ��������)
 VALUES
 (1,'�������'),
 (2, '������������ �����'),
 (3, '�����-���������'),
 (4, '������ �����'),
 (5, '������ �����'),
 (6, '��������� �����'),
  (7,'������ ��������'),
 (8, '����'),
 (9, '������ �����')
GO 
 
INSERT INTO Arzybek.�������
(Id, ��������)
 VALUES
 (1, '�������'),
 (2, '��������'),
 (3, '������������'),
 (4, '����������')
GO 
 
INSERT INTO Arzybek.�����
(Id_�����, Id_�������, Id_��������, ����)
 VALUES
 (1, 4, 5, '25.06.2018'),
 (1, 3, 5, '25.06.2018')
GO 
 
INSERT INTO Arzybek.�����
(Id_�����, Id_�������, Id_��������, ����)
 VALUES
 (2, 4, 1, '14.06.2018'),
 (2, 1, 1, '14.06.2018'),
 (3, 2, 2, '15.06.2018'),
 (3, 3, 2, '15.06.2018'),
 (4, 4, 3, '19.06.2018'),
 (4, 2, 3, '19.06.2018'),
 (5, 3, 4, '20.06.2018'),
 (5, 1, 4, '20.06.2018'),
 (6, 2, 6, '25.06.2018'),
 (6, 1, 6, '25.06.2018')
GO
 
INSERT INTO Arzybek.����
(Id_�������,Id_�����, �����, ����, ���, �������)
 VALUES
 (3, 1, '18:10:00', 1, '������', 4),
 (4, 1, '18:23:00', 0, '�������', 4),
 (3, 1, '19:30:00', 1, '������', 4)
GO
 
INSERT INTO Arzybek.����
(Id_�������, Id_�����, �����, ����, ���, �������)
 VALUES
 (3, 3, '18:29:00', 1, '�������', 3)
GO
 
INSERT INTO Arzybek.����
(Id_�������, Id_�����, �����, ����, ���, �������)
 VALUES
 (2, 4, '21:47:00', 0, '�����', 3),
 (4, 4, '21:59:00', 1, '�������', 4),
 (4, 4, '22:02:00', 1, '�����', 4),
 (2, 4, '22:13:00', 1, '�����', 4)
GO
 
INSERT INTO Arzybek.����
(Id_�������, Id_�����, �����, ����, ���, �������)
 VALUES
 (3, 5, '18:23:00', 1, '������', 4)
GO
 
INSERT INTO Arzybek.����
(Id_�������, Id_�����, �����, ����, ���, �������)
 VALUES
 (1, 6, '17:51:00', 1, '���-������', 3),
 (1, 6, '18:35:00', 1, '���-�������', 3),
 (2, 6, '17:22:00', 1, '�����', 4)
GO
 
INSERT INTO Arzybek.����
(Id_�������, Id_�����, �����, ����, ���, �������)
 VALUES
 (4, 2, '18:12:00', 1, '���������', 2),
 (4, 2, '18:43:00', 1, '�������', 4),
 (4, 2, '19:31:00', 1, '�������', 4),
  (4, 2, '19:11:00', 1, '�����', 3),
   (4, 2, '19:34:00', 1, '�������', 3)
GO
 
INSERT INTO Arzybek.�����
(Id_�����, Id_�������, Id_��������, ����)
 VALUES
 (7, 8, 1, '17.06.2018'),
 (7, 6, 1, '17.06.2018'),
 (8, 5, 7, '18.06.2018'),
 (8, 7, 7, '18.06.2018'),
 (9, 7, 4, '23.06.2018'),
 (9, 6, 4, '23.06.2018'),
 (10, 8, 8, '23.06.2018'),
 (10, 5, 8, '23.06.2018'),
 (11, 7, 9, '27.06.2018'),
 (11, 8, 9, '27.06.2018'),
 (12, 6, 2, '27.06.2018'),
 (12, 5, 2, '27.06.2018')
GO
 
INSERT INTO Arzybek.����
(Id_�������, Id_�����, �����, ����, ���, �������)
 VALUES
 (6, 7, '18:35:00', 1, '������', 4),
 (5, 8, '16:05:00', 1, '���������', 2),
 (6, 9, '18:26:00', 1, '����', 4),
  (8, 10, '21:48:00', 1, '����', 4),
   (7, 11, '18:33:00', 1, '��� �� ����', 3),
   (5, 12, '19:50:00', 1, '�����������', 3)
GO
 
 CREATE SYNONYM �����
FOR Arzybek.[�����]
GO  

CREATE SYNONYM ����
FOR Arzybek.[����]
GO  

CREATE SYNONYM �������
FOR Arzybek.�������
GO  

CREATE SYNONYM �������
FOR Arzybek.�������
GO  

CREATE SYNONYM ��������
FOR Arzybek.��������
GO  


 /****** 1. ������� ������ ������, ������������� �� ������� � ��������.  ******/
 SELECT [������]
      ,[������]
  FROM Arzybek.[�������]
  ORDER BY ������, ������ ASC


/*** ***/
SELECT a.id_����� AS 'Id_�����'
      ,a.id_������� AS 'Id_�������_1'
	  ,b.id_������� AS 'Id_�������_2'
	  ,a.����
	  ,a.id_�������� AS 'Id_��������'
INTO  Arzybek.[TableTwoCommands]
FROM ����� a,����� b
WHERE a.id_�����=b.id_�����  and a.id_�������<b.id_�������
GO
SELECT * FROM Arzybek.[TableTwoCommands]

SELECT id_�����
      ,id_�������
	  ,SUM(CAST(���� AS int))  AS '����'
	  ,COUNT(���� ) - SUM(CAST(���� AS int)) AS '��������'
INTO  Arzybek.[GoalsAutoGoals]
FROM ����
GROUP BY id_�����,id_�������
GO
SELECT * FROM Arzybek.[GoalsAutoGoals]

SELECT  a.Id_����� 
      , a.Id_������� 
      , b.����
	  , b.��������
INTO  Arzybek.[AllGoals]
FROM  ����� a LEFT OUTER JOIN
      Arzybek.[GoalsAutoGoals] b ON a.Id_����� = b.Id_����� AND a.Id_������� = b.Id_�������
GO
UPDATE Arzybek.[AllGoals]
  SET ���� = ISNULL(����,0)
  ,  �������� = ISNULL(��������,0)
SELECT * FROM Arzybek.[AllGoals]

  SELECT a.id_�����
      ,a.id_������� as "Id_�������_1"
	  ,b.id_������� as "Id_�������_2"
	  ,a.���� + b.�������� AS '���� 1'
	  ,b.���� + a.�������� AS '���� 2'
INTO  Arzybek.[TwoTeamsTwoScores]
FROM  Arzybek.[AllGoals] a, Arzybek.[AllGoals] b
WHERE a.Id_�����=b.Id_�����  AND a.Id_������� < b.Id_�������
GO
SELECT * FROM Arzybek.[TwoTeamsTwoScores]

DROP TABLE Arzybek.[FinalTemporary]
SELECT Id_�����
      , Id_�������_1
	  , Id_�������_2
	  , [���� 1]
	  , [���� 2]
	  ,IIF([���� 1] - [���� 2] > 0, 3, IIF([���� 1]- [���� 2]< 0, 0, 1)) AS "���� 1"
	  ,IIF([���� 1] - [���� 2] > 0, 0, IIF([���� 1]- [���� 2] < 0, 3, 1)) AS "���� 2"
INTO  Arzybek.[FinalTemporary]
FROM Arzybek.[TwoTeamsTwoScores]
GO
SELECT * FROM Arzybek.[FinalTemporary]

DROP TABLE Arzybek.[FinalRepresentation]
SELECT b.[��������] AS '�����'
      ,FORMAT (a.����, 'D', 'ru-RU' ) AS '���� �����'
	  ,RTRIM(c.[������]) + ' - ' + RTRIM(d.[������]) AS '���������'
	  ,LTRIM(STR(m.[���� 1])) + ' : ' + LTRIM(STR(m.[���� 2]))  AS '����'
INTO  Arzybek.[FinalRepresentation]
FROM Arzybek.[FinalTemporary] m, Arzybek.[TableTwoCommands] a, Arzybek.[��������] b, ������� c, ������� d
WHERE    m.Id_����� =a.Id_�����
     AND a.Id_��������=b.id_�������� 
	 AND m.Id_�������_1  = c.id
	 AND m.Id_�������_2  = d.id
ORDER BY a.����
GO
SELECT * FROM Arzybek.[FinalRepresentation]
/*** ***/

CREATE SYNONYM TableTwoCommands
FOR Arzybek.[TableTwoCommands]
GO  

CREATE SYNONYM FinalTemporary
FOR Arzybek.[FinalTemporary]
GO  


/****** 2. ������� ������ ������ � ������������ �� ������������ ����  ****/
DROP TABLE Arzybek.[Task2Result]
SELECT b.[��������] AS '�����'
      ,FORMAT (a.����, 'D', 'ru-RU' ) AS '���� �����'
	  ,RTRIM(c.[������]) + ' - ' + RTRIM(d.[������]) AS '���������'
	  ,LTRIM(STR(m.[���� 1])) + ' : ' + LTRIM(STR(m.[���� 2]))  AS '����'
INTO  Arzybek.[Task2Result]
FROM [FinalTemporary] m, [TableTwoCommands] a, Arzybek.[��������] b, ������� c, ������� d
WHERE    m.Id_����� =a.Id_�����
     AND a.Id_��������=b.id_�������� 
	 AND m.Id_�������_1  = c.id
	 AND m.Id_�������_2  = d.id
	 AND a.���� = '25.06.2018'
ORDER BY a.����
GO
SELECT * FROM Arzybek.[Task2Result]

/****** 3. ������� ������ ������ �� ������� (��� ������������ ������) ������������� �� ����� �� ������������ ����.******/
DROP TABLE #TMP1
SELECT c.������
	, sum(f.[���� 1]) as ����
INTO #TMP1
FROM [TableTwoCommands] t, [FinalTemporary] f, ������� c
WHERE  f.Id_����� = t.Id_����� 
	 AND f.Id_�������_1  = c.id 
	 AND t.���� <= '25.06.2018'
	 AND c.������ = 'A'
GROUP BY c.������
UNION
SELECT c.������
	, sum(f.[���� 2]) as ����
FROM [TableTwoCommands] t, [FinalTemporary] f, ������� c
WHERE  f.Id_����� = t.Id_����� 
	 AND f.Id_�������_2  = c.id 
	 AND t.���� <= '25.06.2018'
	 AND c.������ = 'A'
GROUP BY c.������
GO
SELECT * FROM #TMP1

DROP TABLE Arzybek.[T3Result]
SELECT t.������,
	sum(t.����) as [����],
	c.������
INTO Arzybek.[T3Result]
FROM #TMP1 t
INNER JOIN ������� c
ON t.������ = c.������
GROUP BY t.������, c.������
ORDER BY ���� DESC

SELECT * FROM Arzybek.[T3Result]
ORDER BY ���� DESC

/***** 4. ������� �������� ������� �� ������� � ������, �������� � ������������ ������. ****/
DROP TABLE #TMP2
SELECT c.������
	, sum(f.[���� 1]) as ����
	, sum(f.[���� 1]) as ����
	, sum(f.[���� 2]) as ���������
	, c.������
INTO #TMP2
FROM [FinalTemporary] f, ������� c
WHERE f.Id_�������_1  = c.id 
GROUP BY c.������, c.������
UNION
SELECT c.������
	, sum(f.[���� 2]) as ����
	, sum(f.[���� 2]) as ����
	, sum(f.[���� 1]) as ���������
	, c.������
FROM  [FinalTemporary] f, ������� c
WHERE  f.Id_�������_2  = c.id 
GROUP BY c.������, c.������
ORDER BY c.������
GO
SELECT * FROM #TMP2

DROP TABLE Arzybek.[T4Result]
SELECT t.������,
	sum(t.����) as ����,
	sum(t.����) as ����,
	sum(t.���������) as ���������,
	c.������
INTO Arzybek.[T4Result]
FROM #TMP2 t
INNER JOIN ������� c
ON t.������ = c.������
GROUP BY t.������, c.������
ORDER BY ���� DESC

SELECT * FROM Arzybek.[T4Result]
ORDER BY ������, ���� DESC