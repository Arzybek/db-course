USE Arzybek
go

DROP TABLE  Arzybek.Records
go
DROP TABLE  Arzybek.Posts;
go
DROP TABLE  Arzybek.Regions;
go
DROP TABLE  Arzybek.Cars;
go
DROP TABLE  Arzybek.Types;
go

DROP SYNONYM Records
go
DROP SYNONYM Posts
go
DROP SYNONYM Regions
go
DROP SYNONYM Cars
go
DROP SYNONYM Types
go

DROP VIEW CarsView;
GO

DROP TABLE Arzybek.Currencies
CREATE TABLE Arzybek.Currencies
(
	Id TinyInt NOT NULL,
	ShortName NVARCHAR(3) NOT NULL,
	Name NVARCHAR(30) NOT NULL
	CONSTRAINT PkCurrencies PRIMARY KEY (Id)
)
GO

CREATE SYNONYM Currencies
FOR Arzybek.[Currencies]
GO

INSERT INTO Currencies 
(Id, ShortName, Name)
VALUES
	(1,'USD', 'Доллар'),
	(2, 'EUR', 'Евро'),
	(3, 'RUB', 'Рубль')
GO
SELECT * FROM Currencies
GO

DROP TABLE Arzybek.Courses
CREATE TABLE Arzybek.Courses
(
	IdSell TinyInt NOT NULL,
	IdBuy TinyInt NOT NULL,
	Course Decimal(7,4) NOT NULL
	CONSTRAINT PkCourses PRIMARY KEY (IdSell, IdBuy)
)
GO

CREATE SYNONYM Courses
FOR Arzybek.Courses
GO

INSERT INTO Courses
(IdSell, IdBuy, Course)
VALUES
	(1, 3, 63.93),
	(1, 2, 0.91),
	(3, 2, 0.014),
	(3, 1, 0.016),
	(2, 1, 1.1),
	(2, 3, 70.38)
GO
INSERT INTO Courses
(IdSell, IdBuy, Course)
VALUES
	(1, 1, 1),
	(2, 2, 1),
	(3, 3, 1)
GO
SELECT * FROM Courses

DROP TABLE Arzybek.Wallet
CREATE TABLE Arzybek.Wallet
(
	Name NVARCHAR(30) Not Null,
	USD DECIMAL(15,3) Not Null DEFAULT 0.0,
	EUR DECIMAL(15,3) Not Null DEFAULT 0.0,
	RUB DECIMAL(15,3) Not Null DEFAULT 0.0
)
GO

CREATE SYNONYM Wallet
FOR Arzybek.Wallet
GO

DELETE FROM Wallet;
INSERT INTO Wallet 
(Name, USD, RUB, EUR)
VALUES
	('Arzybek', 1, 63, 1)
GO

DROP PROCEDURE CheckMoney;
Go
CREATE PROCEDURE CheckMoney AS
BEGIN
	declare @curcurs cursor
	declare @column nvarchar(3)
	declare @mysql nvarchar(3000);
	declare @value decimal(15,3);

	DECLARE @result table(
	 Валюта nvarchar(3),
	 Количество decimal(15,3)
	);

	set @CurCurs = CURSOR FOR   
		SELECT ShortName
		FROM Currencies

	open @CurCurs

	FETCH NEXT FROM @CurCurs   
	INTO @column  

	WHILE @@FETCH_STATUS = 0  
		BEGIN  
			set @mysql = 'set @value = (SELECT top 1 ' + @column+' from wallet)';
			exec sp_executesql @mysql,	N'@column nvarchar(3), @value decimal(15,3) out', @column = @column, @value = @value out  
			if(@value!=0)
				BEGIN
					Insert into @result VALUES (@column, @value)
				END

			FETCH NEXT FROM @CurCurs   
			INTO @column  
		END   
	CLOSE @CurCurs; 
	select * from @result
END

exec CheckMoney; /*** Проверка всех денег ***/



DROP PROCEDURE CheckHowMuchMoneyIn;
GO
CREATE PROCEDURE CheckHowMuchMoneyIn @nameV NVARCHAR(3), @VALUE Decimal(15,3) output
AS 
BEGIN
	Declare @column nvarchar(3);
	declare @mysql nvarchar(4000);
	set @column = (SELECT c.name  AS 'ColumnName'
		FROM        sys.columns c
		JOIN        sys.tables  t ON c.object_id = t.object_id and t.name LIKE 'Wallet'
		WHERE  c.name LIKE @nameV);
	print(@column)
	set @mysql = 'set @value = (SELECT top 1 ' + @column+' from wallet)';
	--EXEC(@mysql)
	exec sp_executesql @mysql,	N'@column nvarchar(3), @value decimal(15,3) out', @column = @column, @value = @value out  
	print(@value)
end
GO

DECLARE @VALUE Decimal(15,3)
exec CheckHowMuchMoneyIn 'RUB', @VALUE output;    /*** Проверка денег в определенной валюте ***/
GO

DROP Procedure CheckMoneySumIn;
GO
CREATE PROCEDURE CheckMoneySumIn @nameV NVARCHAR(3), @Result Decimal(15,3) output 
AS 
	BEGIN
		Declare @column nvarchar(3);
		declare @mysql nvarchar(4000);
		declare @mysql2 nvarchar(4000);
		declare @CurCurs cursor
		declare @idBuy TinyInt
		declare @idSell TinyInt
		declare @course Decimal(7,4)
		declare @VALUE Decimal(15,3)

		set @result = 0.0

		set @mySql2 = 'set @idBuy = (Select Id From Currencies Where Currencies.ShortName = '  + char(39) + @nameV + char(39)+')';
		exec sp_executesql @mysql2,	N'@nameV nvarchar(3), @idbUy TinyInt out', @nameV = @nameV, @idBuy = @idBuy out  

		set @CurCurs = CURSOR FOR   
		SELECT ShortName
		FROM Currencies  

		open @CurCurs

		FETCH NEXT FROM @CurCurs   
		INTO @column  

		WHILE @@FETCH_STATUS = 0  
			BEGIN  
			set @mysql = 'set @value = (SELECT top 1 ' + @column+' from wallet)';
			exec sp_executesql @mysql,	N'@column nvarchar(3), @value decimal(15,3) out', @column = @column, @value = @value out  

			set @idSell = (Select TOP 1 Id From Currencies Where Currencies.ShortName = @column)

			set @course = (SELECT Course FROM Courses WHERE IdBuy = @idBuy AND IdSell = @idSell)

			set @Result = @Result + @VALUE * @course

			FETCH NEXT FROM @CurCurs   
			INTO @column  
			END   
		CLOSE @CurCurs;  
		DEALLOCATE @CurCurs;  
		Print(cast(@result as nvarchar(30)) + ' '+@nameV)
	end 
GO 

DECLARE @Result Decimal(15,3);
exec CheckMoneySumIn 'RUB', @result output  /*** Проверка суммы денег в определенной валюте ***/
GO

DROP PROCEDURE AddMoneyIn;
Go
CREATE PROCEDURE AddMoneyIn @nameV NVARCHAR(3), @amount DECIMAL(15,3) 
AS
BEGIN
	Declare @column nvarchar(3);
	declare @mysql nvarchar(4000);
	declare @mysql2 nvarchar(4000);
	declare @value decimal(15,3);

	set @column = (SELECT c.name  AS 'ColumnName'
		FROM        sys.columns c
		JOIN        sys.tables  t ON c.object_id = t.object_id and t.name LIKE 'Wallet'
		WHERE  c.name LIKE @nameV);
	print(@column)
	set @mysql = 'set @value = (SELECT top 1 ' + @column+' from wallet)';
	--EXEC(@mysql)
	exec sp_executesql @mysql,	N'@column nvarchar(3), @value decimal(15,3) out', @column = @column, @value = @value out  
	print(@value)
	IF(@value+@amount<0)
		BEGIN
			RAISERROR('Wrong amount',16,1)
			RETURN
		END
	ELSE 
		begin
			set @mysql2 = 'UPDATE Wallet SET ' + @nameV + '= '+@nameV + '+ @amount' 
			exec sp_executesql @mysql2,	N'@nameV nvarchar(3), @amount decimal(15,3)', @nameV = @nameV, @amount = @amount
		end
	exec sp_executesql @mysql,	N'@column nvarchar(3), @value decimal(15,3) out', @column = @column, @value = @value out  
	print(@value)
END
GO

exec AddMoneyIn 'USD', 1
exec AddMoneyIn 'USD', -1   /*** Добавление денег в определенной валюте ***/
select * from wallet
go

DROP PROCEDURE ShowCourses;
go
CREATE PROCEDURE ShowCourses 
AS
BEGIN 
		SELECT a.ShortName AS [Валюта],
				b.ShortName AS [Валюта 2],
				Course 
		INTO #curses
		FROM Currencies a CROSS JOIN Currencies b
		INNER JOIN Courses ON a.Id = Courses.IdBuy AND b.Id = Courses.IdSell
		ORDER BY [Валюта]


		DECLARE @cols  AS NVARCHAR(MAX)='';
		DECLARE @query AS NVARCHAR(MAX)='';
 
		SELECT @cols = @cols + QUOTENAME(ShortName) + ',' FROM (select ShortName from Currencies ) as tmp
		select @cols = substring(@cols, 0, len(@cols)) --trim "," at end
		
		set @query =
		'SELECT * from
		(
			SELECT [Валюта], [Валюта 2], CAST(Course as float) as Course
			FROM #curses
		) as src
		pivot 
		(
		   MAX(Course) for [Валюта 2] in (' + @cols + ')
		) as piv
		'
		execute(@query)
END
GO

exec ShowCourses  /*** Показ таблицы Курсов ***/