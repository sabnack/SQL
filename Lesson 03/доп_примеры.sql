CREATE DATABASE [University]
GO
USE [University]
GO
CREATE TABLE [StudentsMarks]
(
    [Id] INT IDENTITY PRIMARY KEY,
    [FirstName] NVARCHAR(30) NOT NULL,
    [LastName] NVARCHAR(30) NOT NULL,
    [MiddleName] NVARCHAR(30),
    [City] NVARCHAR(20),
    [Country] NVARCHAR(20),
    [BirthDate] DATE NOT NULL,
    [Email] VARCHAR(50),
    [PhoneNumber] VARCHAR(20),
    [GroupName] NVARCHAR(20) NOT NULL,
    [AverageMark] TINYINT,
    [LowestMarkSubject] NVARCHAR(20),
    [HighestMarkSubject] NVARCHAR(20)
)
GO
INSERT INTO [StudentsMarks] (
  [FirstName]
, [LastName]
, [MiddleName]
, [City]
, [Country]
, [BirthDate]
, [Email]
, [PhoneNumber]
, [GroupName]
, [AverageMark]
, [LowestMarkSubject]
, [HighestMarkSubject])
VALUES 
(N'John', N'Smith', N'Steven', N'New York', N'USA', '2000-05-15', 'john.smith@example.com', '+1 (123) 456-7890', N'Group A', 85, N'Mathematics', N'History'),
(N'Elena', N'Sidorova', N'Alexandra', N'Los Angeles', N'USA', '2001-02-20', 'elena.sidorova@example.com', '+1 (987) 654-3210', N'Group B', 78, N'Physics', N'Literature'),
(N'Andrew', N'Ivanov', NULL, N'Chicago', N'USA', '2000-09-10', 'andrew.ivanov@example.com', '+1 (312) 555-1234', N'Group A', 92, N'Chemistry', N'Mathematics'),
(N'Maria', N'Smirnova', N'Vasylivna', N'Miami', N'USA', '2001-04-05', 'maria.smirnova@example.com', '+1 (305) 789-5678', N'Group C', 70, N'Foreign Language', N'Physics'),
(N'Paul', N'Kozlov', N'Igorovich', N'Houston', N'USA', '2000-11-30', 'paul.kozlov@example.com', '+1 (713) 987-6543', N'Group D', 88, N'Computer Science', N'Chemistry'),
(N'Emily', N'Johnson', N'Michelle', N'San Francisco', N'USA', '2000-08-12', 'emily.johnson@example.com', '+1 (415) 123-4567', N'Group A', 90, N'Computer Science', N'English'),
(N'Daniel', N'Williams', N'Robert', N'Boston', N'USA', '2001-03-25', 'daniel.williams@example.com', '+1 (617) 987-6543', N'Group B', 82, N'History', N'Chemistry'),
(N'Olivia', N'Miller', N'Grace', N'Washington, D.C.', N'USA', '2000-11-05', 'olivia.miller@example.com', '+1 (202) 555-7890', N'Group C', 75, N'Literature', N'Mathematics'),
(N'William', N'Jones', N'Henry', N'Chicago', N'USA', '2001-06-18', 'william.jones@example.com', '+1 (312) 555-4321', N'Group D', 88, N'Physics', N'Computer Science'),
(N'Ava', N'Brown', N'Elizabeth', N'Los Angeles', N'USA', '2000-09-30', 'ava.brown@example.com', '+1 (213) 987-3210', N'Group A', 79, N'Foreign Language', N'History');


--Средний балл по группе:
SELECT GroupName, AVG(AverageMark) AS AvgMark
FROM StudentsMarks
GROUP BY GroupName;

--Максимальный балл:
SELECT MAX(AverageMark) AS MaxMark
FROM StudentsMarks;

--Минимальный балл:
SELECT MIN(AverageMark) AS MinMark
FROM StudentsMarks;

--Количество студентов в каждой группе:
SELECT GroupName, COUNT(*) AS StudentCount
FROM StudentsMarks
GROUP BY GroupName;

--Средний возраст студентов:
SELECT AVG(DATEDIFF(YEAR, BirthDate, GETDATE())) AS AvgAge
FROM StudentsMarks;

--Количество студентов с пропущенными оценками:
SELECT COUNT(*) AS MissingMarksCount
FROM StudentsMarks
WHERE AverageMark IS NULL;

--Самый молодой студент:
SELECT TOP 1 FirstName, LastName, BirthDate
FROM StudentsMarks
ORDER BY BirthDate ASC;

--Статистика по странам:
SELECT Country, COUNT(*) AS StudentCount
FROM StudentsMarks
GROUP BY Country;

--Средний балл по предметам:
SELECT AVG(AverageMark) AS AvgMark, LowestMarkSubject, HighestMarkSubject
FROM StudentsMarks
GROUP BY LowestMarkSubject, HighestMarkSubject;

--Количество студентов с электронной почтой:
SELECT COUNT(*) AS StudentsWithEmail
FROM StudentsMarks
WHERE Email IS NOT NULL;

---------------------------------------
--Поиск длины строки:
SELECT LEN(FirstName) AS FirstNameLength
FROM StudentsMarks;

--Преобразование строки в верхний регистр:
SELECT UPPER(LastName) AS UpperLastName
FROM StudentsMarks;

--Преобразование строки в нижний регистр:
SELECT LOWER(FirstName) AS LowerFirstName
FROM StudentsMarks;

--Извлечение подстроки:
SELECT SUBSTRING(Email, 1, 10) AS EmailSubstring
FROM StudentsMarks;

--Поиск позиции подстроки:
SELECT CHARINDEX('gmail', Email) AS GmailPosition
FROM StudentsMarks;

--Удаление начальных и конечных пробелов:
SELECT LTRIM(RTRIM(City)) AS TrimmedCity
FROM StudentsMarks;

--Замена подстроки:
SELECT REPLACE(PhoneNumber, '-', '') AS CleanPhoneNumber
FROM StudentsMarks;

--Поиск позиции первого символа в строке:
SELECT PATINDEX('%[0-9]%', PhoneNumber) AS FirstDigitPosition
FROM StudentsMarks;

--Конкатенация строк:
SELECT CONCAT(FirstName, ' ', LastName) AS FullName
FROM StudentsMarks;

--Поиск ASCII-кода первого символа в имени:
SELECT ASCII(LEFT(FirstName, 1)) AS FirstNameAsciiCode
FROM StudentsMarks;