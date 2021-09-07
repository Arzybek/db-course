USE [Arzybek]
GO

CREATE SCHEMA Arzybek
GO

DROP TABLE  Arzybek.Records
CREATE TABLE Arzybek.Records
(
    PostId TinyInt NOT NULL CHECK(PostId>0 AND PostId<4),
	Direction SmallInt NOT NULL CHECK(Direction = -1 OR Direction = 1),
    Number_Letters NVARCHAR(3) NOT NULL CHECK(UPPER(Number_Letters) = Number_Letters  Collate Latin1_General_CS_AI 
	OR LOWER(Number_Letters) = Number_Letters  Collate Latin1_General_CS_AI),
	Number_Numbers NVARCHAR(3) NOT NULL CHECK(CAST(Number_Numbers as INT) > 0),
	Number_Region NVARCHAR(3) NOT NULL CHECK(CAST(Number_Region as INT) > 0),
    PassageTime TIME NOT NULL,
	CONSTRAINT PK_Records PRIMARY KEY (PostId, Number_Letters, Number_Numbers, Number_Region, PassageTime) 
)
GO

DROP TRIGGER Arzybek.Records_Insert;
go
CREATE TRIGGER Records_Insert
ON Arzybek.[Records]
instead of INSERT
AS 
BEGIN
if exists(
select ii.PostId, ii.direction, ii.Number_Letters, ii.Number_Numbers, ii.Number_Region, ii.PassageTime from inserted ii
INNER JOIN Records ON ii.Number_Numbers = Records.Number_Numbers AND 
ii.Number_Letters = Records.Number_Letters AND ii.Number_Region = Records.Number_Region)
	BEGIN
		insert INTO Arzybek.[Records]
		select ii.PostId, ii.direction, ii.Number_Letters, ii.Number_Numbers, ii.Number_Region, ii.PassageTime from inserted ii
		INNER JOIN Records ON ii.Number_Numbers = Records.Number_Numbers AND ii.Number_Letters = Records.Number_Letters 
		AND ii.Number_Region = Records.Number_Region
		WHERE len(ii.Number_Region) = 3 AND SUBSTRING(ii.Number_Region,1,1) IN ('1','2','7') OR 
			LEN(ii.Number_Region) = 2 
		GROUP BY ii.PostId, ii.direction, ii.Number_Letters, ii.Number_Numbers, 
		ii.Number_Region, ii.PassageTime
		HAVING (SUM(Records.Direction)+ii.Direction) in (-1,0,1);

		Declare @direction Smallint
		Declare @lastPost tinyint
		Declare @currentPost tinyint
		Declare @region NVARCHAR(3)
		Declare @type TINYint
		Declare @lastDirection SmallInt
		Declare @currentDirection SmallInt

		Select @currentPost = (Select ii.PostId from inserted ii)
		Select @region = (Select ii.Number_Region from inserted ii)
		Select @direction = (select SUM(records.Direction) from inserted ii
		INNER JOIN Records ON ii.Number_Letters = Records.Number_Letters AND II.Number_Numbers = records.Number_Numbers 
		AND II.Number_Region = Records.Number_Region)
		Select @currentDirection = (Select ii.Direction from inserted ii)


		Select @lastPost = (select records.PostId from records 
		INNER JOIN inserted ii ON ii.Number_Letters = Records.Number_Letters AND II.Number_Numbers = records.Number_Numbers 
		AND II.Number_Region = Records.Number_Region AND ii.Number_Region = Records.Number_Region
		order by records.PassageTime desc
		OFFSET 1 ROWS
		FETCH NEXT 1 ROW ONLY) 

		Select @lastDirection = (select records.Direction from records 
		INNER JOIN inserted ii ON ii.Number_Letters = Records.Number_Letters AND II.Number_Numbers = records.Number_Numbers 
		AND II.Number_Region = Records.Number_Region AND ii.Number_Region = Records.Number_Region
		order by records.PassageTime desc
		OFFSET 1 ROWS
		FETCH NEXT 1 ROW ONLY) 

		IF EXISTS(select ii.Number_Letters, ii.Number_Numbers, ii.Number_Region from inserted ii INNER JOIN Cars ON 
		ii.Number_Letters = Cars.Number_Letters AND II.Number_Numbers = CARS.Number_Numbers AND II.Number_Region = CARS.Number_Region)
		BEGIN
			if(@lastPost != @currentPost AND @direction = 0 AND @region NOT like '06' AND @lastDirection = 1 AND @currentDirection = -1)
			BEGIN
				UPDATE Cars
				SET Car_Type = 1
				FROM inserted ii inner join Cars on ii.Number_Region = Cars.Number_Region AND ii.Number_Letters = Cars.Number_Letters
				AND ii.Number_Numbers = Cars.Number_Numbers
			END;
			if(@lastPost = @currentPost AND @direction = 0 AND @lastDirection = 1 AND @currentDirection = -1)
			UPDATE Cars
				SET Car_Type = 2
				FROM inserted ii inner join Cars on ii.Number_Region = Cars.Number_Region AND ii.Number_Letters = Cars.Number_Letters
				AND ii.Number_Numbers = Cars.Number_Numbers
			if(@direction = 0 AND @region like '06' AND @lastDirection = -1 AND @currentDirection = 1)
			BEGIN
				UPDATE Cars
				SET Car_Type = 3
				FROM inserted ii inner join Cars on ii.Number_Region = Cars.Number_Region AND ii.Number_Letters = Cars.Number_Letters
				AND ii.Number_Numbers = Cars.Number_Numbers
			END;
			if(@direction = -1 OR @direction = 1)
			BEGIN
				UPDATE Cars
				SET Car_Type = NULL
				FROM inserted ii inner join Cars on ii.Number_Region = Cars.Number_Region AND ii.Number_Letters = Cars.Number_Letters
				AND ii.Number_Numbers = Cars.Number_Numbers
			END;
		END;
	END;
else
	BEGIN
	insert INTO Arzybek.[Records]
	select ii.PostId, ii.direction, ii.Number_Letters, ii.Number_Numbers, ii.Number_Region, ii.PassageTime from inserted ii
	WHERE len(ii.Number_Region) = 3 AND SUBSTRING(ii.Number_Region,1,1) IN ('1','2','7') OR 
		LEN(ii.Number_Region) = 2 
	GROUP BY ii.PostId, ii.direction, ii.Number_Letters, ii.Number_Numbers, 
	ii.Number_Region, ii.PassageTime

	IF(NOT EXISTS(select ii.Number_Letters, ii.Number_Numbers, ii.Number_Region from inserted ii INNER JOIN Cars ON 
	ii.Number_Letters = Cars.Number_Letters AND II.Number_Numbers = CARS.Number_Numbers AND II.Number_Region = CARS.Number_Region))
	BEGIN
		insert INTO Arzybek.Cars
		select NULL, regions.RegionName, ii.Number_Letters, ii.Number_Numbers, ii.Number_Region from inserted ii
		INNER JOIN REgions on ii.Number_Region = regions.RegionId
	END;

	END;
END;
GO

DROP TABLE  Arzybek.Posts;
CREATE TABLE Arzybek.Posts
(
    PostId TinyInt NOT NULL CHECK(PostId>0 AND PostId<5),
	Region nvarchar(3) NOT NULL CHECK(CAST(Region as INT) > 0) DEFAULT '06'
	CONSTRAINT PK_Posts PRIMARY KEY (PostId) 
)
GO

DROP TABLE  Arzybek.Regions;
CREATE TABLE Arzybek.Regions
(
    RegionId NVARCHAR(3) NOT NULL CHECK(CAST(RegionId as INT) > 0),
	RegionName nvarchar(50) NOT NULL,
	CONSTRAINT PK_Regions PRIMARY KEY (RegionId) 
)
GO	

DROP TABLE  Arzybek.Cars;
CREATE TABLE Arzybek.Cars
(
    Car_Type TinyInt NULL CHECK((Car_Type>0 AND Car_Type<4) OR Car_Type is NULL),
	RegionName nvarchar(200) NOT NULL,
    Number_Letters NVARCHAR(3) NOT NULL CHECK(UPPER(Number_Letters) = Number_Letters  Collate Latin1_General_CS_AI 
	OR LOWER(Number_Letters) = Number_Letters  Collate Latin1_General_CS_AI),
	Number_Numbers NVARCHAR(3) NOT NULL CHECK(CAST(Number_Numbers as INT) > 0),
	Number_Region NVARCHAR(3) NOT NULL CHECK(CAST(Number_Region as INT) > 0),
	CONSTRAINT PK_Cars PRIMARY KEY (Number_Letters, Number_Numbers, Number_Region) 
)
GO

DROP TABLE  Arzybek.Types;
CREATE TABLE Arzybek.Types
(
    TypeId TinyInt NOT NULL CHECK((TypeId>0 AND TypeId<4) OR TypeId is NULL),
	TypeName nvarchar(200) NOT NULL,
	CONSTRAINT PK_Type PRIMARY KEY (TypeId)
	-- 1 - transit
	-- 2 - inogorod
	-- 3 - mesntiye 
)
GO
	
CREATE SYNONYM Records
FOR Arzybek.[Records]
GO 

CREATE SYNONYM Posts
FOR Arzybek.[Posts]
GO 

CREATE SYNONYM Regions
FOR Arzybek.[Regions]
GO 

CREATE SYNONYM Cars
FOR Arzybek.Cars
GO 

CREATE SYNONYM Types
FOR Arzybek.Types
GO 

/* DELETE FROM Arzybek.Regions; */
INSERT INTO Regions
(RegionId, RegionName)
 VALUES
 ('02', 'Республика Башкортостан'),
 ('102', 'Республика Башкортостан'),
 ('702', 'Республика Башкортостан'),
 ('06', 'Республика Ингушетия'),
 ('16', 'Республика Татарстан	'),
 ('116', 'Республика Татарстан	'),
 ('716', 'Республика Татарстан	'),
 ('66','Свердловская область'),
 ('96','Свердловская область'),
 ('196','Свердловская область'),
 ('20','Чеченская республика'),
 ('95','Чеченская республика'),
 ('05', 'Республика Дагестан')
GO 
SELECT * FROM REGIONS

/* DELETE FROM Arzybek.Posts; */
INSERT INTO Posts
(PostId)
 VALUES
 ('1'),
 ('2'),
 ('3'),
 ('4')
GO 
SELECT * FROM POSTS

INSERT INTO [Types] 
(typeId, typeName)
 VALUES
 (1, 'Транзитный'),
 (2, 'Иногородний'),
 (3, 'Местный')
GO 
SELECT * FROM Types

ALTER TABLE Arzybek.Records ADD 
	CONSTRAINT FK_Records_ToPosts FOREIGN KEY (PostId) 
	REFERENCES Arzybek.Posts(PostId)
GO	

ALTER TABLE Arzybek.Cars ADD 
	CONSTRAINT FK_Cars_ToTypes FOREIGN KEY (Car_Type) 
	REFERENCES Arzybek.Types(TypeId)
GO	

ALTER TABLE Arzybek.Posts ADD 
	CONSTRAINT FK_Posts_ToRegion FOREIGN KEY (Region) 
	REFERENCES Arzybek.Regions(RegionId)
GO	

ALTER TABLE Arzybek.Records ADD 
	CONSTRAINT FK_Records_ToRegion FOREIGN KEY (Number_Region) 
	REFERENCES Arzybek.Regions(RegionId)
GO	

DELETE FROM Arzybek.[Records];
DELETE FROM Arzybek.[cars];

SELECT * from cars
SELECT * from records

INSERT INTO Records
(PostId, Direction, Number_Letters, Number_Numbers, Number_Region, PassageTime)
 VALUES
 (1, 1, 'ABC', '007', '05', '18:39:00') -- транзитная
GO 

INSERT INTO Records
(PostId, Direction, Number_Letters, Number_Numbers, Number_Region, PassageTime)
 VALUES
  (2, -1, 'ABC', '007', '05', '18:40:00')
go

INSERT INTO Records
(PostId, Direction, Number_Letters, Number_Numbers, Number_Region, PassageTime)
 VALUES
 (2, 1, 'ABC', '008', '116', '18:40:00') -- иногородняя
GO 

INSERT INTO Records
(PostId, Direction, Number_Letters, Number_Numbers, Number_Region, PassageTime)
 VALUES
 (2, -1, 'ABC', '008', '116', '18:41:00')
 GO

 INSERT INTO Records
(PostId, Direction, Number_Letters, Number_Numbers, Number_Region, PassageTime)
 VALUES
 (2, 1, 'ABC', '008', '05', '18:42:00') -- пересчет иногородней на транзитную
 GO

 INSERT INTO Records
(PostId, Direction, Number_Letters, Number_Numbers, Number_Region, PassageTime)
 VALUES
 (1, -1, 'ABC', '008', '05', '18:50:00')
 GO

 INSERT INTO Records
(PostId, Direction, Number_Letters, Number_Numbers, Number_Region, PassageTime)
 VALUES
 (2, -1, 'ABC', '008', '06', '18:40:00') -- местная
GO 

INSERT INTO Records
(PostId, Direction, Number_Letters, Number_Numbers, Number_Region, PassageTime)
 VALUES
 (1, 1, 'ABC', '008', '06', '18:42:00')
 GO

SELECT * from records
SELECT * from cars
go

DROP VIEW CarsView;
GO
CREATE VIEW CarsView AS 
SELECT SUBSTRING(cc.Number_Letters, 1,1)+cc.Number_Numbers+SUBSTRING(cc.Number_Letters,2,2)+cc.Number_Region as 'Номер', 
cc.RegionName as 'Регион', IIF(cc.Car_Type=1, 'Транзитная', IIF(cc.Car_Type=2, 'Иногородняя', 'Местная')) as 'Тип машины'
from Cars cc
go
SELECT * From CarsView;

-- TESTS
DELETE FROM Arzybek.[Records];
GO
/* Тест региона */
INSERT INTO Records
(PostId, Direction, Number_Letters, Number_Numbers, Number_Region, PassageTime)
 VALUES
 (1, -1, 'ABC', '007', '005', '18:39:00')
GO 
SELECT * FROM RECORDS


/* Тест въезда/выезда */
INSERT INTO Records
(PostId, Direction, Number_Letters, Number_Numbers, Number_Region, PassageTime)
 VALUES
 (1, -1, 'ABC', '133', '05','18:36:00')
GO 
INSERT INTO Records
(PostId, Direction, Number_Letters, Number_Numbers, Number_Region, PassageTime)
 VALUES
 (1, -1, 'ABC', '133', '05', '18:37:00')
GO 
SELECT * from records

/* PostId test */
INSERT INTO Records
(PostId, Direction, Number_Letters, Number_Numbers, Number_Region, PassageTime)
 VALUES
 (0, -1, 'ABC', '133', '05', '18:37:00')
GO 
SELECT * from records
/* Direction test */
INSERT INTO Records
(PostId, Direction, Number_Letters, Number_Numbers, Number_Region, PassageTime)
 VALUES
 (1, 2, 'ABC', '133', '05', '18:37:00')
GO 
DELETE FROM Records;
/*Letters test*/
INSERT INTO Records
(PostId, Direction, Number_Letters, Number_Numbers, Number_Region, PassageTime)
 VALUES
 (1, 1, 'ABс', '133', '05', '18:37:00')
GO 
INSERT INTO Records
(PostId, Direction, Number_Letters, Number_Numbers, Number_Region, PassageTime)
 VALUES
 (1, 1, 'abC', '133', '05', '18:37:00')
GO 

/*Numbers test*/
INSERT INTO Records
(PostId, Direction, Number_Letters, Number_Numbers, Number_Region, PassageTime)
 VALUES
 (1, 1, 'ABC', '-13', '05', '18:37:00')
GO 