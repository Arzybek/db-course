/*** ВАРИАНТ 9 ***/
USE Arzybek
go

DROP TABLE  Arzybek.Courses
go

DROP SYNONYM Currencies
go

DROP PROCEDURE ShowCourses;
GO

DROP TABLE Arzybek.Abonents
CREATE TABLE Arzybek.Abonents
(
	Id Int NOT NULL PRIMARY KEY,
	Name NVARCHAR(100) NOT NULL,
	Surname NVARCHAR(100) NOT NULL,
	Patronymic NVARCHAR(100) NULL,
	Address NVARCHAR(200) NOT NULL,
	PhoneNumber NVARCHAR(10) NOT NULL CHECK(try_convert(bigint,PhoneNumber) is not null),
	CONSTRAINT UK_Abonents UNIQUE (Name,Surname,Patronymic)
)
GO

CREATE SYNONYM Abonents
FOR Arzybek.[Abonents]
GO

Delete from Abonents;
INSERT INTO Abonents
VALUES
	(1,'Batman', 'Wayne', NULL, 'Gotham', '3221337777'),
	(2,'Джокер', 'Доминикович', NULL, 'г. Готэм', '1234567890')
GO
SELECT * FROM Abonents

DROP TABLE Arzybek.Books
CREATE TABLE Arzybek.Books
(
	ID Int not null primary key, 
	Name NVARCHAR(100) NOT NULL,
	Authors NVARCHAR(200) NOT NULL,
	Izdatelstvo NVARCHAR(100) NOT NULL,
	Place NVARCHAR(100) Not null,
	Year SMALLINT CHECK(Year>0 AND YEAR<3000) NOT NULL,
	PagesCount SMALLINT CHECK(PagesCount>0) NOT NULL,
	CONSTRAINT UK_Books UNIQUE (Name,Authors,Year)
)
GO

CREATE SYNONYM Books
FOR Arzybek.[Books]
GO
DELETE FROM Books
GO
INSERT INTO Books
VALUES
	(1,'Основы математического анализа','Фихтенгольц Г.М.', 'Наука', 'Москва', '1968', '441')
GO
INSERT INTO Books
VALUES
	(2,'Гарри Поттер и Философский камень','Джоан К. Роулинг', 'Росмэн', 'Москва', '2003', '361')
GO	
SELECT * FROM BOOKS

DROP TABLE Arzybek.Biblio;
CREATE TABLE Arzybek.Biblio
(
	IDBook Int NOT NULL,
	Cipher INT NOT NULL CHECK(Cipher>0),
	Price INT NOT NULL CHECK(Price>0),
	CountBook INT Not Null Check(CountBook>=0),
	CONSTRAINT PkBook PRIMARY KEY (IDBook)
)
GO

ALTER TABLE Arzybek.Biblio ADD
	CONSTRAINT FK_Books FOREIGN KEY (IDbook) 
	REFERENCES Arzybek.Books(Id)
GO	
CREATE SYNONYM Biblio
FOR Arzybek.Biblio
GO

INSERT INTO Biblio
VALUES
	(1, 1, 100, 1000),
	(2, 11, 99, 100)
GO
SELECT * FROM Biblio

DROP TABLE  Arzybek.Records
CREATE TABLE Arzybek.Records
(
	IDBook INT Not null,
	DateGiven DATE NOT NULL,
	DateReturned DATE NULL,
	IDAbonent INT Not null
	constraint PK_Records PRIMARY KEY (IDbook, IDAbonent, DateGiven)
)
GO

CREATE SYNONYM Records
FOR Arzybek.Records
GO
ALTER TABLE Arzybek.Records ADD
	CONSTRAINT FK_Book FOREIGN KEY (IDbook) 
	REFERENCES Arzybek.Books(Id)
GO	
ALTER TABLE Arzybek.Records ADD
	CONSTRAINT FK_Abonent FOREIGN KEY (IdAbonent) 
	REFERENCES Arzybek.Abonents(Id)
GO	

DROP TRIGGER Arzybek.Records_Insert;
go
CREATE TRIGGER Records_Insert
ON Arzybek.[Records]
instead of INSERT
AS 
BEGIN
	declare @returned date
	declare @given date
	declare @idBook smallint
	declare @iduser smallint 

	declare @curreturned cursor
	declare @curidbook cursor
	declare @curgiven cursor
	declare @curiduser cursor

	set @CurReturned = CURSOR FOR   
		SELECT DateReturned
		FROM inserted
	set @curgiven = CURSOR FOR   
		SELECT DateGiven
		FROM inserted
	set @CurIDBook = CURSOR FOR   
		SELECT IDBook
		FROM inserted
	set @CurIDUser = CURSOR FOR   
		SELECT IDAbonent
		FROM inserted

	open @CurIDBook
	open @CurReturned
	open @CurGiven
	open @CurIdUser

	FETCH NEXT FROM @CurIDbook
	INTO @idbook
	FETCH NEXT FROM @CurReturned   
	INTO @returned 
	FETCH NEXT FROM @CurGiven
	INTO @given
	FETCH NEXT FROM @CurIdUser   
	INTO @iduser 


	WHILE @@FETCH_STATUS = 0  
		BEGIN  
		if(@returned is Null)
		BEGIN
			UPDATE Biblio
			SET CountBook -=1
			WHERE Biblio.IDBook = @idBook

			Insert into Records VALUES (@idBook, @given, @returned, @iduser)

			FETCH NEXT FROM @CurIDbook
			INTO @idbook
			FETCH NEXT FROM @CurReturned   
			INTO @returned 
			FETCH NEXT FROM @CurGiven
			INTO @given
			FETCH NEXT FROM @CurIdUser   
			INTO @iduser 
		END
	end
	close @curreturned
	close @curidbook
END
GO

INSERT INTO Records
VALUES
	(1, '2019-12-10', NULL, 1),
	(1, '2019-11-10', NULL, 2)
GO
select * from biblio
SELECT * FROM Records

DROP TABLE  Arzybek.Orders
CREATE TABLE Arzybek.Orders
(
	IDBook INT Not null,
	DateOrder DATE NOT NULL,
	IDAbonent INT Not null
	constraint PK_Orders PRIMARY KEY (IDbook, IDAbonent, DateOrder)
)
GO

CREATE SYNONYM Orders
FOR Arzybek.Orders
GO
ALTER TABLE Arzybek.Orders ADD
	CONSTRAINT FK_OrderBook FOREIGN KEY (IDbook) 
	REFERENCES Arzybek.Books(Id)
GO	
ALTER TABLE Arzybek.Orders ADD
	CONSTRAINT FK_OrderAbonent FOREIGN KEY (IdAbonent) 
	REFERENCES Arzybek.Abonents(Id)
GO	

INSERT INTO Orders
VALUES
	(2, '2019-12-10', 2)
GO
SELECT * FROM Orders


DROP FUNCtion GetAllPersonsBooks
go
CREATE Function GetAllPersonsBooks(@name nvarchar(100), @surname nvarchar(100), @patr nvarchar = null)
RETURNs @result table (
	[Имя] nvarchar(100), 
	[Авторы] nvarchar(200),
	[Издательство] nvarchar(100),
	[Город] nvarchar(100),
	[Год] smallint,
	[Кол-во страниц] smallint,
	[Дата выдачи] date,
	[Дата возврата] date,
	[Ф.И.О] nvarchar(max)
)
AS 
	begin 
		INSERT INTO @result 
		(
			Имя,
			Авторы,
			Издательство,
			Город,
			Год,
			[Кол-во страниц], 
			[Дата выдачи],
			[Дата возврата],
			[Ф.И.О]
		)
		SELECT Arzybek.Books.Name,
		Authors,
		Izdatelstvo,
		Place,
		Year,
		PagesCount,
		DateGiven,
		DateReturned,
		CONCAT(Abonents.Name, ' ', Abonents.Surname, ' ', Abonents.Patronymic)
		from records INNER JOIN Arzybek.Books ON IdBook = ID
		INNER JOIN Arzybek.Abonents ON records.IDAbonent = Abonents.Id
		WHERE Abonents.Name LIKE @name AND Abonents.Surname like @surname AND (Abonents.Patronymic = @patr OR Abonents.Patronymic is null)
return
end
go

select * from Abonents;
SELECT * FROM GetAllPersonsBooks('Джокер', 'Доминикович', DEFAULT);

DROP FUNCtion GetAllPersonsBooks
go
CREATE Function GetBooksAllPersons(@name nvarchar(200))
RETURNs @result table (
	[Дата выдачи] date,
	[Ф.И.О] nvarchar(max)
)
AS 
	begin 
		INSERT INTO @result 
		( 
			[Дата выдачи],
			[Ф.И.О]
		)
		SELECT 
		DateGiven,
		CONCAT(Abonents.Name, ' ', Abonents.Surname, ' ', Abonents.Patronymic)
		from records INNER JOIN Arzybek.Books ON IdBook = ID
		INNER JOIN Arzybek.Abonents ON records.IDAbonent = Abonents.Id
		WHERE Books.Name LIKE @name
return
end
go

SELECT * FROM GetBooksAllPersons('Основы математического анализа');


DROP Procedure ReturnBook
go
CREATE PROCEDURE ReturnBook @date date, @nameBook nvarchar(200), @namePerson nvarchar(100), @surname nvarchar(100), @patr nvarchar(100) = null AS
BEGIN
		UPDATE Biblio
		SET CountBook +=1
		from Biblio 
		inner join Books
		on Biblio.IDBook = Books.ID
		WHERE Books.Name = @nameBook

		UPDATE Records
		SET DateReturned = @date
		from Records
		inner join Abonents
		on Records.IDAbonent = Abonents.Id
		WHERE Abonents.Name = @namePerson and Abonents.Surname = @surname and (Abonents.Patronymic = @patr or Abonents.Patronymic is Null) 
		Print(concat(@namePerson,' updated ', @nameBook,' on date ', @date))
end
go

exec ReturnBook '2019-11-12', 'Основы математического анализа', 'Джокер', 'Доминикович'

DROP Procedure GetMostReadPerson
go
CREATE PROCEDURE GetMostReadPerson @from date, @to date AS
BEGIN
		SELECT 
		CONCAT(Abonents.Name, ' ', Abonents.Surname, ' ', Abonents.Patronymic) as ФИО,
		count(records.DateGiven) as [Кол-во]
		from records
		INNER JOIN Arzybek.Abonents ON records.IDAbonent = Abonents.Id
		WHERE records.DateGiven >= @from and records.DateReturned is not null and Records.DateReturned <= @to
		Group by Abonents.Name, Abonents.Surname, Abonents.Patronymic
end
go


INSERT INTO Records
VALUES
	(2, '2019-12-10', NULL, 1)
GO
select * from biblio
SELECT * FROM Records

exec GetMostReadPerson '2019-01-01','2019-12-31'

DROP Procedure GetMostBook
go
CREATE PROCEDURE GetMostBook
as begin
		SELECT top 1
		Books.Name as Имя,
		Books.Authors as Авторы,
		Books.Year as Год,
		Biblio.CountBook as Количество
		from Biblio
		INNER JOIN Arzybek.Books ON Biblio.IDBook = Books.Id
		Order by Biblio.CountBook DESC
end
go

exec GetMostBook


DROP Procedure GetMostOrderedBook
go
CREATE PROCEDURE GetMostOrderedBook
as begin
		SELECT top 1
		Books.Name as Имя,
		Books.Authors as Авторы,
		Books.Year as Год,
		count(Orders.IDBook) as Количество
		from Orders
		INNER JOIN Arzybek.Books ON Orders.IDBook = Books.Id
		GROUP BY Books.Name, Books.Authors, Books.Year, Orders.IDBook
end
go

select * from orders
exec GetMostOrderedBook

DROP Procedure GetMostReadedBook
go
CREATE PROCEDURE GetMostReadedBook  @from date, @to date 
as begin
		SELECT top 1
		Books.Name as Имя,
		Books.Authors as Авторы,
		Books.Year as Год,
		count(Records.IDBook) as Количество
		from Records
		INNER JOIN Arzybek.Books ON Records.IDBook = Books.Id
		WHERE records.DateGiven >= @from and (Records.DateReturned <= @to or Records.DateReturned is null)
		GROUP BY Books.Name, Books.Authors, Books.Year, Records.IDBook
end
go 

select * from records
exec GetMostReadedBook '2019-01-01','2019-12-31'




