USE Arzybek
go
DROP SYNONYM Currencies
go
DROP PROCEDURE ShowCourses;
GO
DROP TABLE Arzybek.Abonents
GO
DROP SYNONYM Abonents
DROP TABLE Arzybek.Books
DROP SYNONYM Books
DROP TABLE Arzybek.Biblio;
DROP SYNONYM Biblio
DROP TABLE  Arzybek.Records
DROP SYNONYM Records
DROP TRIGGER Arzybek.Records_Insert;
go
DROP TABLE  Arzybek.Orders
DROP SYNONYM Orders
DROP FUNCtion GetAllPersonsBooks
go
DROP FUNCtion GetAllPersonsBooks
go
DROP Procedure ReturnBook
go
DROP Procedure GetMostReadPerson
go
DROP Procedure GetMostBook
go
DROP Procedure GetMostOrderedBook
go
DROP Procedure GetMostReadedBook
go

DROP TABLE Arzybek.Tariff
GO
CREATE TABLE Arzybek.Tariff
(
	Id tinyint identity NOT NULL,
	Name nvarchar(100) NOT NULL,
	Payment money NOT NULL, 
	Minutes_Amount float NOT NULL,
	Minute_Cost money NOT NULL
    CONSTRAINT PK_Tariff PRIMARY KEY (ID)
)
GO

CREATE SYNONYM Tariff FOR Arzybek.Tariff;

DELETE FROM Tariff;
INSERT INTO Arzybek.Tariff VALUES
(N'Поминутный', 0, 0, 0.5),
(N'Безлимитный', 12500, 44640, 0),
(N'Смешанный', 2999, 12000, 1)
GO
--INSERT INTO Arzybek.Tariff VALUES
--(N'Поминутный', 0, 0, 0.5),
--(N'Смешанный', 2, 6, 1),
--(N'Безлимитный', 5, 44640, 0)
--GO


DROP FUNCTION dbo.Best_Tariff
GO
CREATE FUNCTION Best_Tariff(@minutes_IN float)
RETURNS nvarchar(100)
AS
BEGIN
	IF @minutes_IN < 0
	BEGIN
		return 'Minutes should be positive number';
	END
	IF @minutes_IN > 44640
	BEGIN
		return 'Minutes are bigger than minutes in one month';
	END

	DECLARE @name nvarchar(100), @pay money, @minutes float, @cost money
	DECLARE @result nvarchar(100), @current float, @last float
	SET @last = 0
	SET @current = 0

	DECLARE @cursor CURSOR
	SET @cursor =  CURSOR FOR SELECT Name, Payment, Minutes_Amount, Minute_Cost FROM Arzybek.Tariff

	OPEN @cursor
	FETCH NEXT FROM @cursor INTO @name, @pay, @minutes, @cost
	WHILE @@FETCH_STATUS = 0
	BEGIN
			IF @minutes_IN <= @minutes 
			BEGIN
				SET @current = @pay		
			END
			ELSE
			BEGIN
				SET @current = @pay + (@minutes_IN - @minutes) * @cost
			END

			IF @last = 0 OR @current < @last
			BEGIN 
				SET @last = @current
				SET @result = @name
			END
			FETCH NEXT FROM @cursor INTO @name, @pay, @minutes, @cost
	END
	CLOSE @cursor
	DEALLOCATE @cursor
	RETURN @result
END
GO

print(dbo.Best_Tariff(1000));   -- поминутный

print(dbo.Best_Tariff(6000));
print(dbo.Best_Tariff(12000));
print(dbo.Best_Tariff(18000));  -- смешанный

print(dbo.Best_Tariff(18002));
print(dbo.Best_Tariff(24999));  -- поминутный

print(dbo.Best_Tariff(25001));   -- безлимитный
print(dbo.Best_Tariff(40000)); 

print(dbo.Best_Tariff(46650));   -- ошибки
print(dbo.Best_Tariff(-1)); 

DROP PROCEDURE BestTariffForSegments
GO
CREATE PROCEDURE BestTariffForSegments
AS
BEGIN
	DECLARE @max int
	CREATE TABLE #table 
	(
		Point float
	)
	INSERT INTO #table VALUES 
	 (0), (44640)

	INSERT INTO #table SELECT MAX(Minutes_Amount) FROM Arzybek.Tariff;
	SET @max = 44640

	----Пересечение безлимитного A с поминутным B
	--INSERT INTO #table 
	--SELECT 
	----A.Name, B.Name
	--(A.Payment-B.Payment)/B.Minute_Cost
	--FROM Arzybek.Tariff as A, Arzybek.Tariff as B
	--WHERE A.Id<>B.Id AND B.Minute_Cost <> 0 AND (A.Payment- B.Payment)/B.Minute_Cost > 0

	--Пересечение безлимитного A с поминутным B, смешанного A с поминутным B, Безлимитного A со смешанным B
	INSERT INTO #table 
	SELECT 
	--A.Name, B.Name,
	((A.Payment-B.Payment)/B.Minute_Cost + B.Minutes_Amount)
	--,B.Minutes_Amount
	FROM Arzybek.Tariff as A, Arzybek.Tariff as B
	WHERE A.Id<>B.Id AND B.Minute_Cost <> 0 AND (A.Payment - B.Payment)/B.Minute_Cost > 0

	--пересечение поминутного A с смешанным B
	INSERT INTO #table
	SELECT 
	--A.Name, B.Name,
	(B.Payment - A.Payment - B.Minutes_Amount*B.Minute_Cost + A.Minutes_Amount*A.Minute_Cost)/(A.Minute_Cost - B.Minute_Cost)
	--, B.Payment, B.Minutes_Amount, B.Minute_Cost
	FROM Arzybek.Tariff as A, Arzybek.Tariff as B
	WHERE A.Id<>B.Id AND (B.Minutes_Amount - A.Minutes_Amount) > 0 AND (A.Minute_Cost - B.Minute_Cost) <> 0 AND
	(B.Payment - A.Payment - B.Minutes_Amount*B.Minute_Cost + A.Minutes_Amount*A.Minute_Cost)/(A.Minute_Cost - B.Minute_Cost) > 0
	
	UPDATE #table SET Point=ROUND(Point,0)
	DELETE FROM #table WHERE
					Point != 0
					AND Point != @max
					AND  dbo.best_tariff(Point-1) = dbo.best_tariff(Point+1) 
					AND  dbo.best_tariff(Point) = dbo.best_tariff(Point+1) 

	CREATE TABLE #result (
		left_point int, 
		right_point int, 
		tariff nvarchar(40)
	)

	DECLARE @cursor CURSOR, @left int, @right int
	SET @cursor = CURSOR FOR SELECT DISTINCT * FROM #table ORDER BY Point ASC
	OPEN @cursor
	FETCH NEXT FROM @cursor INTO @left
	FETCH NEXT FROM @cursor INTO @right
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO #result VALUES (@left, @right, dbo.best_tariff((@left+@right)/2))
		SET @left=@right
		FETCH NEXT FROM @cursor INTO @right
	END
	SELECT CONCAT('[', left_point, ';', right_point, ']') as Отрезок,		   
		   tariff as [Тариф]
		   FROM #result 
END
GO

EXEC BestTariffForSegments
go

--DROP PROCEDURE TimeLimits
--GO
--CREATE PROC Timelimits AS 
--begin
--	DECLARE
--		@counter int = 0,

--		@id1 int,
--		@f_subscription int,
--		@f_minutes_limit int,
--		@f_pay_over_limit float,

--		@id2 int,
--		@s_subscription int,
--		@s_minutes_limit int,
--		@s_pay_over_limit float,

--		@f_crossing_point float,
--		@s_crossing_point float,

--		@f_coord float,
--		@s_coord float
	
--		CREATE TABLE #Crossing_points(
--			p_id int, 
--			coords float
--		)
		
--		CREATE TABLE #Limits(
--			fromtime float, 
--			totime float, 
--			tarif nvarchar(100)
--		)

--		INSERT INTO #Crossing_points
--		VALUES ( 
--			@counter, 0
--		)
--		SET @counter +=1 

--		DECLARE cur1 CURSOR FOR SELECT Id, Payment, Minutes_Amount, Minute_Cost from Arzybek.Tariff ORDER By Payment
		
--		OPEN cur1
--		FETCH NEXT FROM cur1 INTO @id1, @f_subscription, @f_minutes_limit, @f_pay_over_limit
--		WHILE @@FETCH_STATUS = 0
--			BEGIN 
--				DECLARE cur2 CURSOR FOR
--				SELECT id, Payment, Minutes_Amount, Minute_Cost FROM Arzybek.Tariff
--				WHERE Payment> @f_subscription 
--				ORDER BY Payment
--				OPEN cur2
--				FETCH NEXT FROM cur2 INTO @id2, @s_subscription, @s_minutes_limit, @s_pay_over_limit
--				WHILE @@FETCH_STATUS = 0
--					BEGIN
--						SET @f_crossing_point = (@s_subscription - @f_subscription) / @f_pay_over_limit + @f_minutes_limit
--						SET @s_crossing_point = (@f_subscription - @s_subscription + @s_minutes_limit * @s_pay_over_limit - @f_minutes_limit * @f_pay_over_limit) / (@s_pay_over_limit - @f_pay_over_limit)
--						IF(@s_crossing_point > @s_minutes_limit)
--							BEGIN
--								INSERT INTO #Crossing_points
--								VALUES ( @counter, CEILING(@s_crossing_point))
--								SET @counter +=1
--							END
--						IF(@f_crossing_point < @s_minutes_limit)
--							BEGIN
--								INSERT INTO #Crossing_points
--								VALUES ( @counter, CEILING(@f_crossing_point) )
--								SET @counter +=1
--							END
--						FETCH NEXT FROM cur2 INTO @id2, @s_subscription, @s_minutes_limit, @s_pay_over_limit
--					END
--					CLOSE cur2
--					DEALLOCATE cur2
--			FETCH NEXT FROM cur1 INTO @id1, @f_subscription, @f_minutes_limit, @f_pay_over_limit
--			END
--		CLOSE cur1
--		DEALLOCATE cur1

----		select * from #Crossing_points
--		DECLARE cur3 CURSOR FOR
--		SELECT coords FROM #Crossing_points ORDER BY coords
--		OPEN cur3
--		FETCH NEXT FROM cur3 INTO @f_coord
--		WHILE(@@FETCH_STATUS = 0)
--		BEGIN
--			FETCH NEXT FROM cur3 INTO @s_coord

--			IF (dbo.Best_Tariff(@f_coord) != dbo.Best_Tariff(@s_coord))
--				BEGIN
--					INSERT INTO #Limits
--					VALUES ( CEILING(@f_coord), CEILING(@s_coord - 1),(SELECT Name FROM Arzybek.Tariff WHERE dbo.Best_Tariff(@f_coord) = Name))
--					SET @f_coord =  CEILING(@s_coord)

--				END
--		END
--		INSERT INTO #Limits
--		VALUES ( CEILING(@f_coord),44640,(SELECT Name FROM Arzybek.Tariff WHERE dbo.best_tariff(@f_coord) = Name))

--		CLOSE cur3
--		DEALLOCATE cur3

--		SELECT * FROM #Limit
--end
--GO

--EXEC Timelimits
--GO