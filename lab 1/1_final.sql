USE [Arzybek]
GO

IF OBJECT_ID('Arzybek.Голы', 'U') IS NOT NULL
  DROP TABLE  Arzybek.Голы
GO

IF OBJECT_ID('Arzybek.Матчи', 'U') IS NOT NULL
  DROP TABLE  Arzybek.Матчи
GO

IF OBJECT_ID('Arzybek.Команда', 'U') IS NOT NULL
  DROP TABLE  Arzybek.Команда
GO

IF OBJECT_ID('Arzybek.Позиции', 'U') IS NOT NULL
  DROP TABLE  Arzybek.Позиции
GO

IF OBJECT_ID('Arzybek.Стадионы', 'U') IS NOT NULL
  DROP TABLE  Arzybek.Стадионы
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

CREATE TABLE Arzybek.Голы
(
    Id_Матча TinyInt NOT NULL,
	Id_Команды TinyInt NOT NULL,
	Голы bit NOT NULL,
    Имя VARCHAR(40) NOT NULL,
    Время TIME NOT NULL,
    Позиция TinyInt NOT NULL
)
GO

CREATE TABLE Arzybek.Матчи
(
    Id_Матча TinyInt NOT NULL,
    Id_Команды TinyInt NOT NULL,
    Дата DateTime NOT NULL,
    Id_Стадиона TinyInt NOT NULL,
    CONSTRAINT PK_Матчи PRIMARY KEY (Id_Матча, Id_Команды)
)
GO
 
CREATE TABLE Arzybek.Команда
(
    Страна VARCHAR(40) NOT NULL,
    Группа CHAR(1) NOT NULL,  
    Id TinyInt NOT NULL
)
GO
 
CREATE TABLE Arzybek.Стадионы
(
    Id_стадиона TinyInt NOT NULL,
    Название VARCHAR(40) NOT NULL,  
)
GO
 
CREATE TABLE Arzybek.Позиции
(
    Название VARCHAR(40) NOT NULL,
    Id TinyInt NOT NULL,
)
GO
	
ALTER TABLE Arzybek.Голы ADD
	CONSTRAINT PK_Goals PRIMARY KEY (Id_Матча, Id_команды, Время) 
GO	

ALTER TABLE Arzybek.Команда ADD
	CONSTRAINT PK_Team PRIMARY KEY (Id) 
GO		

ALTER TABLE Arzybek.Стадионы ADD
	CONSTRAINT PK_Stadium PRIMARY KEY (Id_стадиона) 
GO	

ALTER TABLE Arzybek.Позиции ADD
	CONSTRAINT PK_Pos PRIMARY KEY (Id) 
GO	

ALTER TABLE Arzybek.Голы ADD
	CONSTRAINT FK_Goals FOREIGN KEY (Id_Матча, Id_Команды) 
	REFERENCES Arzybek.Матчи(Id_Матча, Id_Команды)
GO	

ALTER TABLE Arzybek.Матчи ADD
	CONSTRAINT FK_Team_1 FOREIGN KEY (Id_Команды) 
	REFERENCES Arzybek.Команда(Id)
GO		

ALTER TABLE Arzybek.Матчи ADD
	CONSTRAINT FK_Stadium FOREIGN KEY (Id_Стадиона) 
	REFERENCES Arzybek.Стадионы(Id_стадиона)
GO		

ALTER TABLE Arzybek.Голы ADD
	CONSTRAINT FK_Pos FOREIGN KEY (Позиция) 
	REFERENCES Arzybek.Позиции(Id)
GO		   
 
INSERT INTO Arzybek.Команда
(Страна, Группа, Id)
 VALUES
 ('Уругвай', 'A', 3),
 ('Россия','A' , 4)
 ,('Египет','A',2)
 ,('Саудовская Аравия','A',1)   ,
  ('Швеция', 'F', 5),
 ('Мексика','F' , 6)
 ,('Республика Корея','F', 7)
 ,('Германия','F', 8)  
GO 
 
INSERT INTO Arzybek.Стадионы
(Id_стадиона, Название)
 VALUES
 (1,'Лужники'),
 (2, 'Екатеринбург арена'),
 (3, 'Санкт-Петербург'),
 (4, 'Ростов Арена'),
 (5, 'Самара арена'),
 (6, 'Волгоград арена'),
  (7,'Нижний Новгород'),
 (8, 'Фишт'),
 (9, 'Казань Арена')
GO 
 
INSERT INTO Arzybek.Позиции
(Id, Название)
 VALUES
 (1, 'Вратарь'),
 (2, 'Защитник'),
 (3, 'Полузащитник'),
 (4, 'Нападающий')
GO 
 
INSERT INTO Arzybek.Матчи
(Id_матча, Id_команды, Id_Стадиона, Дата)
 VALUES
 (1, 4, 5, '25.06.2018'),
 (1, 3, 5, '25.06.2018')
GO 
 
INSERT INTO Arzybek.Матчи
(Id_матча, Id_команды, Id_Стадиона, Дата)
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
 
INSERT INTO Arzybek.Голы
(Id_Команды,Id_Матча, Время, Голы, Имя, Позиция)
 VALUES
 (3, 1, '18:10:00', 1, 'Суарес', 4),
 (4, 1, '18:23:00', 0, 'Черышев', 4),
 (3, 1, '19:30:00', 1, 'Кавани', 4)
GO
 
INSERT INTO Arzybek.Голы
(Id_Команды, Id_Матча, Время, Голы, Имя, Позиция)
 VALUES
 (3, 3, '18:29:00', 1, 'Хименес', 3)
GO
 
INSERT INTO Arzybek.Голы
(Id_Команды, Id_Матча, Время, Голы, Имя, Позиция)
 VALUES
 (2, 4, '21:47:00', 0, 'Фатхи', 3),
 (4, 4, '21:59:00', 1, 'Черышев', 4),
 (4, 4, '22:02:00', 1, 'Дзюба', 4),
 (2, 4, '22:13:00', 1, 'Салах', 4)
GO
 
INSERT INTO Arzybek.Голы
(Id_Команды, Id_Матча, Время, Голы, Имя, Позиция)
 VALUES
 (3, 5, '18:23:00', 1, 'Суарес', 4)
GO
 
INSERT INTO Arzybek.Голы
(Id_Команды, Id_Матча, Время, Голы, Имя, Позиция)
 VALUES
 (1, 6, '17:51:00', 1, 'аль-Фарадж', 3),
 (1, 6, '18:35:00', 1, 'аль-Давсари', 3),
 (2, 6, '17:22:00', 1, 'Салах', 4)
GO
 
INSERT INTO Arzybek.Голы
(Id_Команды, Id_Матча, Время, Голы, Имя, Позиция)
 VALUES
 (4, 2, '18:12:00', 1, 'Газинский', 2),
 (4, 2, '18:43:00', 1, 'Черышев', 4),
 (4, 2, '19:31:00', 1, 'Черышев', 4),
  (4, 2, '19:11:00', 1, 'Дзюба', 3),
   (4, 2, '19:34:00', 1, 'Головин', 3)
GO
 
INSERT INTO Arzybek.Матчи
(Id_матча, Id_команды, Id_Стадиона, Дата)
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
 
INSERT INTO Arzybek.Голы
(Id_Команды, Id_Матча, Время, Голы, Имя, Позиция)
 VALUES
 (6, 7, '18:35:00', 1, 'Лосано', 4),
 (5, 8, '16:05:00', 1, 'Гранквист', 2),
 (6, 9, '18:26:00', 1, 'Вела', 4),
  (8, 10, '21:48:00', 1, 'Ройс', 4),
   (7, 11, '18:33:00', 1, 'Ким Ён Гвон', 3),
   (5, 12, '19:50:00', 1, 'Аугустинсон', 3)
GO
 
 CREATE SYNONYM Матчи
FOR Arzybek.[Матчи]
GO  

CREATE SYNONYM Голы
FOR Arzybek.[Голы]
GO  

CREATE SYNONYM Команда
FOR Arzybek.Команда
GO  

CREATE SYNONYM Позиции
FOR Arzybek.Позиции
GO  

CREATE SYNONYM Стадионы
FOR Arzybek.Стадионы
GO  


 /****** 1. Вывести список команд, упорядоченный по группам и алфавиту.  ******/
 SELECT [Страна]
      ,[Группа]
  FROM Arzybek.[Команда]
  ORDER BY Группа, Страна ASC


/*** ***/
SELECT a.id_Матча AS 'Id_Матча'
      ,a.id_Команды AS 'Id_Команды_1'
	  ,b.id_Команды AS 'Id_Команды_2'
	  ,a.Дата
	  ,a.id_Стадиона AS 'Id_Стадиона'
INTO  Arzybek.[TableTwoCommands]
FROM Матчи a,Матчи b
WHERE a.id_Матча=b.id_Матча  and a.id_Команды<b.id_Команды
GO
SELECT * FROM Arzybek.[TableTwoCommands]

SELECT id_Матча
      ,id_Команды
	  ,SUM(CAST(Голы AS int))  AS 'Голы'
	  ,COUNT(Голы ) - SUM(CAST(Голы AS int)) AS 'Автоголы'
INTO  Arzybek.[GoalsAutoGoals]
FROM Голы
GROUP BY id_Матча,id_Команды
GO
SELECT * FROM Arzybek.[GoalsAutoGoals]

SELECT  a.Id_Матча 
      , a.Id_Команды 
      , b.Голы
	  , b.Автоголы
INTO  Arzybek.[AllGoals]
FROM  Матчи a LEFT OUTER JOIN
      Arzybek.[GoalsAutoGoals] b ON a.Id_Матча = b.Id_Матча AND a.Id_Команды = b.Id_Команды
GO
UPDATE Arzybek.[AllGoals]
  SET Голы = ISNULL(Голы,0)
  ,  Автоголы = ISNULL(Автоголы,0)
SELECT * FROM Arzybek.[AllGoals]

  SELECT a.id_матча
      ,a.id_команды as "Id_Команды_1"
	  ,b.id_команды as "Id_Команды_2"
	  ,a.Голы + b.Автоголы AS 'Счёт 1'
	  ,b.Голы + a.Автоголы AS 'Счёт 2'
INTO  Arzybek.[TwoTeamsTwoScores]
FROM  Arzybek.[AllGoals] a, Arzybek.[AllGoals] b
WHERE a.Id_Матча=b.Id_Матча  AND a.Id_Команды < b.Id_Команды
GO
SELECT * FROM Arzybek.[TwoTeamsTwoScores]

DROP TABLE Arzybek.[FinalTemporary]
SELECT Id_Матча
      , Id_Команды_1
	  , Id_Команды_2
	  , [Счёт 1]
	  , [Счёт 2]
	  ,IIF([Счёт 1] - [Счёт 2] > 0, 3, IIF([Счёт 1]- [Счёт 2]< 0, 0, 1)) AS "Очки 1"
	  ,IIF([Счёт 1] - [Счёт 2] > 0, 0, IIF([Счёт 1]- [Счёт 2] < 0, 3, 1)) AS "Очки 2"
INTO  Arzybek.[FinalTemporary]
FROM Arzybek.[TwoTeamsTwoScores]
GO
SELECT * FROM Arzybek.[FinalTemporary]

DROP TABLE Arzybek.[FinalRepresentation]
SELECT b.[Название] AS 'Арена'
      ,FORMAT (a.Дата, 'D', 'ru-RU' ) AS 'Дата матча'
	  ,RTRIM(c.[Страна]) + ' - ' + RTRIM(d.[Страна]) AS 'Соперники'
	  ,LTRIM(STR(m.[Счёт 1])) + ' : ' + LTRIM(STR(m.[Счёт 2]))  AS 'Счет'
INTO  Arzybek.[FinalRepresentation]
FROM Arzybek.[FinalTemporary] m, Arzybek.[TableTwoCommands] a, Arzybek.[Стадионы] b, Команда c, Команда d
WHERE    m.Id_Матча =a.Id_Матча
     AND a.Id_Стадиона=b.id_стадиона 
	 AND m.Id_Команды_1  = c.id
	 AND m.Id_Команды_2  = d.id
ORDER BY a.Дата
GO
SELECT * FROM Arzybek.[FinalRepresentation]
/*** ***/

CREATE SYNONYM TableTwoCommands
FOR Arzybek.[TableTwoCommands]
GO  

CREATE SYNONYM FinalTemporary
FOR Arzybek.[FinalTemporary]
GO  


/****** 2. Вывести список матчей с результатами на определенную дату  ****/
DROP TABLE Arzybek.[Task2Result]
SELECT b.[Название] AS 'Арена'
      ,FORMAT (a.Дата, 'D', 'ru-RU' ) AS 'Дата матча'
	  ,RTRIM(c.[Страна]) + ' - ' + RTRIM(d.[Страна]) AS 'Соперники'
	  ,LTRIM(STR(m.[Счёт 1])) + ' : ' + LTRIM(STR(m.[Счёт 2]))  AS 'Счет'
INTO  Arzybek.[Task2Result]
FROM [FinalTemporary] m, [TableTwoCommands] a, Arzybek.[Стадионы] b, Команда c, Команда d
WHERE    m.Id_Матча =a.Id_Матча
     AND a.Id_Стадиона=b.id_стадиона 
	 AND m.Id_Команды_1  = c.id
	 AND m.Id_Команды_2  = d.id
	 AND a.Дата = '25.06.2018'
ORDER BY a.Дата
GO
SELECT * FROM Arzybek.[Task2Result]

/****** 3. Вывести список команд по группам (для определенной группы) упорядоченный по очкам на определенную дату.******/
DROP TABLE #TMP1
SELECT c.Страна
	, sum(f.[Очки 1]) as Очки
INTO #TMP1
FROM [TableTwoCommands] t, [FinalTemporary] f, Команда c
WHERE  f.Id_Матча = t.Id_Матча 
	 AND f.Id_Команды_1  = c.id 
	 AND t.Дата <= '25.06.2018'
	 AND c.Группа = 'A'
GROUP BY c.Страна
UNION
SELECT c.Страна
	, sum(f.[Очки 2]) as Очки
FROM [TableTwoCommands] t, [FinalTemporary] f, Команда c
WHERE  f.Id_Матча = t.Id_Матча 
	 AND f.Id_Команды_2  = c.id 
	 AND t.Дата <= '25.06.2018'
	 AND c.Группа = 'A'
GROUP BY c.Страна
GO
SELECT * FROM #TMP1

DROP TABLE Arzybek.[T3Result]
SELECT t.Страна,
	sum(t.Очки) as [Очки],
	c.Группа
INTO Arzybek.[T3Result]
FROM #TMP1 t
INNER JOIN Команда c
ON t.Страна = c.Страна
GROUP BY t.Страна, c.Группа
ORDER BY Очки DESC

SELECT * FROM Arzybek.[T3Result]
ORDER BY Очки DESC

/***** 4. Вывести итоговую таблицу по группам с очками, забитыми и пропущенными мячами. ****/
DROP TABLE #TMP2
SELECT c.Страна
	, sum(f.[Очки 1]) as Очки
	, sum(f.[Счёт 1]) as Голы
	, sum(f.[Счёт 2]) as Пропущено
	, c.Группа
INTO #TMP2
FROM [FinalTemporary] f, Команда c
WHERE f.Id_Команды_1  = c.id 
GROUP BY c.Страна, c.Группа
UNION
SELECT c.Страна
	, sum(f.[Очки 2]) as Очки
	, sum(f.[Счёт 2]) as Голы
	, sum(f.[Счёт 1]) as Пропущено
	, c.Группа
FROM  [FinalTemporary] f, Команда c
WHERE  f.Id_Команды_2  = c.id 
GROUP BY c.Страна, c.Группа
ORDER BY c.Группа
GO
SELECT * FROM #TMP2

DROP TABLE Arzybek.[T4Result]
SELECT t.Страна,
	sum(t.Очки) as Очки,
	sum(t.Голы) as Голы,
	sum(t.Пропущено) as Пропущено,
	c.Группа
INTO Arzybek.[T4Result]
FROM #TMP2 t
INNER JOIN Команда c
ON t.Страна = c.Страна
GROUP BY t.Страна, c.Группа
ORDER BY Очки DESC

SELECT * FROM Arzybek.[T4Result]
ORDER BY Группа, Очки DESC