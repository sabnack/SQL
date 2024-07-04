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

-- Відображення всієї інформації з таблиці зі студентами та оцінками.
SELECT * FROM [StudentsMarks]

-- Відображення ПІБ усіх студентів.
SELECT [FirstName], [LastName], [MiddleName] FROM [StudentsMarks]

-- Відображення усіх середніх оцінок.
SELECT [AverageMark] FROM [StudentsMarks]

-- Показати країни студентів. Назви країн мають бути унікальними.
SELECT DISTINCT [Country] FROM [StudentsMarks]

-- Показати міста студентів. Назви міст мають бути унікальними.
SELECT DISTINCT [City] FROM [StudentsMarks] 

-- Показати назви груп. Назви груп мають бути унікальними.
SELECT DISTINCT [GroupName] FROM [StudentsMarks]

-------------------------------------------
CREATE DATABASE MyShopDemo
GO
USE MyShopDemo
GO
CREATE TABLE Products
(
    Id INT IDENTITY PRIMARY KEY,
    ProductName NVARCHAR(30) NOT NULL,
    Manufacturer NVARCHAR(20) NOT NULL,
    ProductCount INT DEFAULT 0,
    Price MONEY NOT NULL
);
 
INSERT INTO Products 
VALUES
('iPhone 6', 'Apple', 3, 36000),
('iPhone 6S', 'Apple', 2, 41000),
('iPhone 7', 'Apple', 5, 52000),
('Galaxy S8', 'Samsung', 2, 46000),
('Galaxy S8 Plus', 'Samsung', 1, 56000),
('Mi6', 'Xiaomi', 5, 28000),
('OnePlus 5', 'OnePlus', 6, 38000)

-- Оператор LIKE приймає шаблон рядка, якому має відповідати вираз.
-- WHERE выражение [NOT] LIKE шаблон_строки

--Для визначення шаблону може застосовуватися ряд спеціальних символів підстановки:

--% : відповідає будь-якому підрядку, який може мати будь-яку кількість символів, 
-- при цьому підрядок може і не містити жодного символу

--_ : відповідає будь-якому одиночному символу

--[ ] : відповідає одному символу, який вказаний у квадратних дужках

--[ - ] : відповідає одному символу з певного діапазону

--[ ^ ] : відповідає одному символу, який не вказано після символу ^

--Деякі приклади використання підстановок:
SELECT * FROM Products
WHERE ProductName LIKE 'Galaxy%'

--Відповідає таким значенням як "Galaxy Ace 2" або "Galaxy S7"

SELECT * FROM Products
WHERE ProductName LIKE 'Galaxy S_'

--Відповідає таким значенням як "Galaxy S7" або "Galaxy S8"

SELECT * FROM Products
WHERE ProductName LIKE 'iPhone [78]'

--Відповідає таким значенням як iPhone 7 або iPhone 8

SELECT * FROM Products
WHERE ProductName LIKE 'iPhone [6-8]'

--Відповідає таким значенням як iPhone 6, iPhone 7 або iPhone8

SELECT * FROM Products
WHERE ProductName LIKE 'iPhone [^7]%'

--Відповідає таким значенням як iPhone 6, iPhone 6S або iPhone8. Але не відповідає значенням "iPhone 7" та "iPhone 7S"

SELECT * FROM Products
WHERE ProductName LIKE 'iPhone [^1-6]%'

--Відповідає таким значенням як iPhone 7, iPhone 7S і iPhone 8. 
--Але не відповідає значенням "iPhone 5", "iPhone 6" та "iPhone 6S"

----
SELECT * FROM Products
WHERE ProductName LIKE 'iPhone [6-8]%'

--
SELECT * FROM Products
WHERE ProductName LIKE '%one%'

---------------------------
-- Для зміни вже наявних рядків у таблиці застосовується команда UPDATE . Вона має такий формальний синтаксис:

--UPDATE имя_таблицы
--SET столбец1 = значение1, столбец2 = значение2, ... столбецN = значениеN
--[FROM выборка AS псевдоним_выборки]
--[WHERE условие_обновления]

--
UPDATE Products
SET Price = Price + 5000

--
UPDATE Products
SET Manufacturer = 'Samsung Inc.'
WHERE Manufacturer = 'Samsung'

----------------------
-- Для видалення застосовується команда DELETE:
-- DELETE [FROM] имя_таблицы
-- WHERE условие_удаления

--
DELETE Products
WHERE Id=9

--
DELETE Products
WHERE Manufacturer='Xiaomi' AND Price < 15000

--
DELETE Products FROM
(SELECT TOP 2 * FROM Products
WHERE Manufacturer='Apple') AS Selected
WHERE Products.Id = Selected.Id

-- Якщо необхідно видалити всі рядки незалежно від умови, то умову можна не вказувати:
DELETE Products

-- удаляем все и сбрасываем счетчик Identity, но сработает только если нет зависимостей с другими таблицами
TRUNCATE TABLE Products
---------------------------------------

-- Функції для роботи з рядками

--Для роботи з рядками у T-SQL можна застосовувати такі функції:

--LEN : повертає кількість символів у рядку. Як параметр у функцію передається рядок, для якого треба знайти довжину:

SELECT LEN('Apple')  -- 5
--LTRIM : видаляє початкові пробіли з рядка. Як параметр приймає рядок:

SELECT LTRIM('  Apple')
--RTRIM : видаляє кінцеві пропуски з рядка. Як параметр приймає рядок:

SELECT RTRIM(' Apple    ')
--CHARINDEX : повертає індекс, за яким знаходиться перше входження підрядка в рядку. Як перший параметр передається підрядок, а як другий - рядок, в якому треба вести пошук:

SELECT CHARINDEX('pl', 'Apple') -- 3
--PATINDEX : повертає індекс, яким знаходиться перше входження певного шаблону в рядку:

SELECT PATINDEX('%p_e%', 'Apple')   -- 3
--LEFT : вирізує з початку рядка певну кількість символів. Перший параметр функції – рядок, а другий – кількість символів, які треба вирізати спочатку рядки:

SELECT LEFT('Apple', 3) -- App
--RIGHT : вирізує з кінця рядка певну кількість символів. Перший параметр функції – рядок, а другий – кількість символів, які треба вирізати спочатку рядки:

SELECT RIGHT('Apple', 3)    -- ple
--SUBSTRING : вирізає з рядка підрядок певною довжиною, починаючи з певного індексу. Співаний параметр функції - рядок, другий - початковий індекс для вирізки, і третій параметр - кількість символів, що вирізуються:

SELECT SUBSTRING('Galaxy S8 Plus', 8, 2)    -- S8
--REPLACE : замінює один підрядок на інший в рамках рядка. Перший параметр функції - рядок, другий - підрядок, який треба замінити, а третій - підрядок, на який треба замінити:

SELECT REPLACE('Galaxy S8 Plus', 'S8 Plus', 'Note 8')   -- Galaxy Note 8
--REVERSE : перевертає рядок навпаки:

SELECT REVERSE('123456789') -- 987654321
--CONCAT : об'єднує два рядки в один. Як параметр приймає від 2-х і більше рядків, які треба з'єднати:

SELECT CONCAT('Tom', ' ', 'Smith')  -- Tom Smith
--LOWER : перекладає рядок у нижній регістр:

SELECT LOWER('Apple')   -- apple
--UPPER : перекладає рядок у верхній регістр

SELECT UPPER('Apple')   -- APPLE
--SPACE : повертає рядок, який містить певну кількість прогалин

--
CREATE TABLE Products
(
    Id INT IDENTITY PRIMARY KEY,
    ProductName NVARCHAR(30) NOT NULL,
    Manufacturer NVARCHAR(20) NOT NULL,
    ProductCount INT DEFAULT 0,
    Price MONEY NOT NULL
);

go

SELECT UPPER(LEFT(Manufacturer,2)) AS Abbreviation,
       CONCAT(ProductName, ' - ',  Manufacturer) AS FullProdName
FROM Products
ORDER BY Abbreviation

-----------------------
--Для роботи з числовими даними T-SQL надає низку функцій:

--ROUND : Заокруглює число. Як перший параметр передається число. Другий параметр вказує на довжину. Якщо довжина представляє позитивне число, воно вказує, до якої цифри після коми йде округлення. Якщо довжина представляє від'ємне число, воно вказує, до якої цифри з кінця числа до коми йде округлення

SELECT ROUND(1342.345, 2)   -- 1342.350
SELECT ROUND(1342.345, -2)  -- 1300.000
--ISNUMERIC : визначає, чи є значення числом. Як параметр функція приймає вираз. Якщо вираз є числом, функція повертає 1. Якщо не є, то повертається 0.

SELECT ISNUMERIC(1342.345)          -- 1
SELECT ISNUMERIC('1342.345')        -- 1
SELECT ISNUMERIC('SQL')         -- 0
SELECT ISNUMERIC('13-04-2017')  -- 0
--ABS : повертає абсолютне значення числа.

SELECT ABS(-123)    -- 123
--CEILING : повертає найменше ціле число, яке більше або дорівнює поточному значенню.

SELECT CEILING(-123.45)     -- -123
SELECT CEILING(123.45)      -- 124
--FLOOR : повертає найбільше ціле число, яке менше або дорівнює поточному значенню.

SELECT FLOOR(-123.45)       -- -124
SELECT FLOOR(123.45)        -- 123
--SQUARE : зводить число квадрат.

SELECT SQUARE(5)        -- 25
--SQRT : отримує квадратний корінь числа.

SELECT SQRT(225)        -- 15
--RAND : генерує випадкове число з точкою, що плаває, в діапазоні від 0 до 1.

SELECT RAND()       -- 0.707365088352935
SELECT RAND()       -- 0.173808327956812
--COS : повертає косинус кута, вираженого в радіанах

SELECT COS(1.0472)  -- 0.5 - 60 градусов
--SIN : повертає синус кута, вираженого в радіанах

SELECT SIN(1.5708)  -- 1 - 90 градусов
--TAN : повертає тангенс кута, вираженого в радіанах

SELECT TAN(0.7854)  -- 1 - 45 градусов

---
CREATE TABLE Products
(
    Id INT IDENTITY PRIMARY KEY,
    ProductName NVARCHAR(30) NOT NULL,
    Manufacturer NVARCHAR(20) NOT NULL,
    ProductCount INT DEFAULT 0,
    Price MONEY NOT NULL
);

--Округлимо добуток ціни товару на кількість цього товару:

SELECT ProductName, ROUND(Price * ProductCount, 2)
FROM Products

-----------------------------
-- Функції по роботі з датами та часом

--T-SQL надає ряд функцій для роботи з датами та часом:

--GETDATE : повертає поточну локальну дату та час на основі системного годинника у вигляді об'єкта datetime

SELECT GETDATE()    -- 2017-07-28 21:34:55.830
--GETUTCDATE : повертає поточну локальну дату та час за гринвічем (UTC/GMT) у вигляді об'єкта datetime

SELECT GETUTCDATE()     -- 2017-07-28 18:34:55.830
--SYSDATETIME : повертає поточну локальну дату та час на основі системного годинника, але відмінність від GETDATE полягає в тому, що дата та час повертаються у вигляді об'єкта datetime2

SELECT SYSDATETIME()        -- 2017-07-28 21:02:22.7446744
--SYSUTCDATETIME : повертає поточну локальну дату та час за гринвічем (UTC/GMT) у вигляді об'єкта datetime2

SELECT SYSUTCDATETIME()     -- 2017-07-28 18:20:27.5202777
--SYSDATETIMEOFFSET : повертає об'єкт datetimeoffset(7), який містить дату та час щодо GMT

SELECT SYSDATETIMEOFFSET()      -- 2017-07-28 21:02:22.7446744 +03:00
--DAY : повертає день дати, який передається як параметр

SELECT DAY(GETDATE())       -- 28
--MONTH : повертає місяць дати

SELECT MONTH(GETDATE())     -- 7
--YEAR : повертає рік з дати

SELECT YEAR(GETDATE())      -- 2017
--DATENAME : повертає частину дати у вигляді рядка. Параметр вибору частини дати передається як перший параметр, 
--а сама дата передається як другий параметр:

SELECT DATENAME(month, GETDATE())       -- July
--Для визначення частини дати можна використовувати такі параметри (у дужках вказано їх скорочені версії):

--year (yy, yyyy): рік

--quarter (qq, q): околиці

--month (mm, m): місяць

--dayofyear (dy, y): день року

--day (dd, d): день місяця

--week (wk, ww): неділя

--weekday (dw): день тижня

--hour (hh): час

--minute (mi, n): хвилини

--second (ss, s): другий

--millisecond (ms): мілісекунди

--microsecond (mcs): мікросекунда

--nanosecond (ns): наносекунда

--tzoffset (tz): змішання у хвилинах щодо грінвіча (для об'єкта datetimeoffset)

--DATEPART : повертає частину дати у вигляді числа. Параметр вибору частини дати передається як перший параметр (використовуються ті ж параметри, що і для DATENAME), а сама дата передається як другий параметр:

SELECT DATEPART(month, GETDATE())       -- 7
--DATEADD : повертає дату, яка є результатом додавання числа до певного компонента дати. Першим параметром є компонент дати, описаний вище для функції DATENAME. Другий параметр - кількість, що додається. Третій параметр - сама дата, до якої треба зробити додаток:

SELECT DATEADD(month, 2, '2017-7-28')       -- 2017-09-28 00:00:00.000
SELECT DATEADD(day, 5, '2017-7-28')     -- 2017-08-02 00:00:00.000
SELECT DATEADD(day, -5, '2017-7-28')        -- 2017-07-23 00:00:00.000
--Якщо кількість, що додається, представляє негативне число, то фактично відбувається зменшення дати.

--DATEDIFF : повертає різницю між двома датами. Перший параметр – компонент дати, який вказує, у яких одиницях варто вимірювати різницю. Другий та третій параметри - порівнювані дати:

SELECT DATEDIFF(year, '2017-7-28', '2018-9-28')     -- разница 1 год
SELECT DATEDIFF(month, '2017-7-28', '2018-9-28')    -- разница 14 месяцев
SELECT DATEDIFF(day, '2017-7-28', '2018-9-28')      -- разница 427 дней
--TODATETIMEOFFSET : повертає значення datetimeoffset, яке є результатом складання тимчасового зміщення з об'єктом datetime2

SELECT TODATETIMEOFFSET('2017-7-28 01:10:22', '+03:00')
--SWITCHOFFSET : повертає значення datetimeoffset, яке є результатом складання тимчасового зміщення з іншим об'єктом datetimeoffset

SELECT SWITCHOFFSET(SYSDATETIMEOFFSET(), '+02:30')
--EOMONTH : повертає дату останнього дня для місяця, який використовується в переданій даті.

SELECT EOMONTH('2017-02-05')    -- 2017-02-28
SELECT EOMONTH('2017-02-05', 3) -- 2017-05-31
--Як необов'язковий другий параметр можна передавати кількість місяців, які необхідно додати до дати. 
--Тоді останній день місяця обчислюватиметься для нової дати.

--DATEFROMPARTS : за роком, місяцем та днем ​​створює дату

SELECT DATEFROMPARTS(2017, 7, 28)       -- 2017-07-28
--ISDATE : перевіряє, чи є вираз датою. Якщо є, то повертає 1 інакше повертає 0.

SELECT ISDATE('2017-07-28')     -- 1
SELECT ISDATE('2017-28-07')     -- 0
SELECT ISDATE('28-07-2017')     -- 0
SELECT ISDATE('SQL')            -- 0

---
CREATE TABLE Orders
(
    Id INT IDENTITY PRIMARY KEY,
    ProductId INT NOT NULL,
    CustomerId INT NOT NULL,
    CreatedAt DATE NOT NULL DEFAULT GETDATE(),
    ProductCount INT DEFAULT 1,
    Price MONEY NOT NULL
);
-- Вираз DEFAULT GETDATE() вказує, що якщо при додаванні даних не передається дата,
-- вона автоматично обчислюється за допомогою функції GETDATE().

-- Інший приклад – знайдемо замовлення, які були зроблені 16 днів тому:

SELECT * FROM Orders
WHERE DATEDIFF(day, CreatedAt, GETDATE()) = 16

-------------------------------
-- Перетворення даних

--Коли ми надаємо значення одного типу стовпцю, який зберігає дані іншого типу, або виконуємо операції, які залучають дані різних типів, 
--SQL Server намагається виконати перетворення і привести значення до потрібного типу. 
--Але не всі перетворення SQL Server може виконати автоматично. 
--SQL Server може виконувати неявні перетворення від типу з меншим пріоритетом до типу з більшим пріоритетом. 
--Таблиця пріоритетів (що вище, тим більший пріоритет):

--datetime
--smalldatetime
--float
--real
--decimal
--money
--smallmoney
--int
--smallint
--tinyint
--bit
--nvarchar
--nchar
--varchar
--char

--Тобто SQL Server автоматично може перетворити число 100.0 (float) на дату та час (datetime).

--У тих випадках, коли необхідно виконати перетворення від типів із вищим пріоритетом до типів із нижчим пріоритетом,
--то треба виконувати явне приведення типів. Для цього в T-SQL визначено дві функції: CONVERT та CAST .

-- CAST(выражение AS тип_данных)

--
SELECT Id, CAST(CreatedAt AS nvarchar) + '; total: ' + CAST(Price * ProductCount AS nvarchar) 
FROM Orders

-- Більшість перетворень охоплює функція CAST. Якщо ж необхідне додаткове форматування, то можна використовувати функцію CONVERT .
-- Вона має таку форму:

-- CONVERT(тип_данных, выражение [, стиль])

--Третій необов'язковий параметр визначає стиль форматування даних. 
--Цей параметр є числове значення, яке для різних типів даних має різну інтерпретацію. 
--Наприклад, деякі значення для форматування дат та часу:

--0 або 100- формат дати "Mon dd yyyy hh:miAM/PM" (за замовчуванням)

--1 або 101- формат дати "мм/дд/рррр"

--3 або 103- формат дати "дд/мм/рррр"

--7 або 107- формат дати "Mon dd, yyyy hh:miAM/PM"

--8 або 108- формат дати "гг:мі:сс"

--10 або 110- формат дати "мм-дд-рррр"

--14 або 114- формат дати "hh:mi:ss:mmmm" (24-годинний формат часу)

--Деякі значення для форматування даних типу money у рядок:

--0- у дробовій частині числа залишаються лише дві цифри (за замовчуванням)

--1- у дробовій частині числа залишаються тільки дві цифри, а для поділу розрядів застосовується кома

--2- у дробовій частині числа залишаються лише чотири цифри

-- Наприклад, виведемо дату та вартість замовлень із форматуванням:

SELECT CONVERT(nvarchar, CreatedAt, 3), 
       CONVERT(nvarchar, Price * ProductCount, 1) 
FROM Orders

-- TRY_CONVERT

-- У разі використання функцій CAST та CONVERT SQL Server викидає виняток, якщо дані не можуть призвести до певного типу. Наприклад:
	
SELECT CONVERT(int, 'sql')

-- Щоб уникнути генерації виключення, можна використовувати функцію TRY_CONVERT . 
-- Її використання аналогічно функції CONVERT за винятком, що й вираз не вдається перетворити до потрібного типу, то функція повертає NULL:

SELECT TRY_CONVERT(int, 'sql')      -- NULL
SELECT TRY_CONVERT(int, '22')       -- 22

--Додаткові функції
--Крім CAST, CONVERT, TRY_CONVERT є ще ряд функцій, які можуть використовуватися для перетворення на ряд типів:

--STR(float [, length [,decimal]]) : перетворює число в рядок. 
--Другий параметр вказує на довжину рядка, а третій - скільки знаків у дрібній частині числа треба залишати

--CHAR(int) : перетворює числовий код ASCII на символ. 
--Нерідко використовується для тих ситуацій, коли потрібний символ, який не можна ввести з клавіатури

--ASCII(char) : перетворює символ на числовий код ASCII

--NCHAR(int) : перетворює числовий код UNICODE на символ

--UNICODE(char) : перетворює символ на числовий код UNICODE

SELECT STR(123.4567, 6,2)   -- 123.46
SELECT CHAR(219)            --  Ы
SELECT ASCII('Ы')           -- 219
SELECT NCHAR(1067)          -- Ы
SELECT UNICODE('Ы')     -- 1067

----------------------
-- Агрегатні функції

--Агрегатні функції виконують обчислення над значеннями набору рядків. У T-SQL є такі агрегатні функції:

--AVG : знаходить середнє значення

--SUM : знаходить суму значень

--MIN : знаходить найменше значення

--MAX : знаходить найбільше значення

--COUNT : знаходить кількість рядків у запиті

--Як аргумент всі агрегатні функції приймають вираз, який представляє критерій для визначення значень. 
--Найчастіше, як вираз виступає назва стовпця, над значеннями якого треба проводити обчислення.

--Вирази у функціях AVG та SUM мають бути числовими. Вираз у функціях MIN , MAX та COUNT може представляти числове чи рядкове значення чи дату.

--Усі агрегатні функції крім COUNT(*)ігнорують значення NULL.

CREATE TABLE Products
(
    Id INT IDENTITY PRIMARY KEY,
    ProductName NVARCHAR(30) NOT NULL,
    Manufacturer NVARCHAR(20) NOT NULL,
    ProductCount INT DEFAULT 0,
    Price MONEY NOT NULL
);
  
INSERT INTO Products 
VALUES
('iPhone 6', 'Apple', 3, 36000),
('iPhone 6S', 'Apple', 2, 41000),
('iPhone 7', 'Apple', 5, 52000),
('Galaxy S8', 'Samsung', 2, 46000),
('Galaxy S8 Plus', 'Samsung', 1, 56000),
('Mi6', 'Xiaomi', 5, 28000),
('OnePlus 5', 'OnePlus', 6, 38000)

-- 	
SELECT AVG(Price) AS Average_Price FROM Products

--
SELECT AVG(Price) FROM Products
WHERE Manufacturer='Apple'

--	
SELECT AVG(Price * ProductCount) FROM Products

--
SELECT COUNT(*) FROM Products

--
SELECT COUNT(Manufacturer) FROM Products

--
SELECT MIN(Price) FROM Products

--
SELECT MAX(Price) FROM Products

--
SELECT SUM(ProductCount) FROM Products

--
SELECT SUM(ProductCount * Price) FROM Products

--
SELECT AVG(DISTINCT ProductCount) AS Average_Price FROM Products

--
SELECT AVG(ALL ProductCount) AS Average_Price FROM Products

--
SELECT COUNT(*) AS ProdCount,
       SUM(ProductCount) AS TotalCount,
       MIN(Price) AS MinPrice,
       MAX(Price) AS MaxPrice,
       AVG(Price) AS AvgPrice
FROM Products

-----------------------------
-- Оператори GROUP BY та HAVING

--Для групування даних у T-SQL застосовуються оператори GROUP BY та HAVING , для використання яких застосовується наступний формальний синтаксис:

--SELECT столбцы
--FROM таблица
--[WHERE условие_фильтрации_строк]
--[GROUP BY столбцы_для_группировки]
--[HAVING условие_фильтрации_групп]
--[ORDER BY столбцы_для_сортировки]

--
-- Оператор GROUP BY визначає, як рядки групуватимуться.
SELECT Manufacturer, COUNT(*) AS ModelsCount
FROM Products
GROUP BY Manufacturer

-- Перший стовпець у виразі SELECT - Manufacturer представляє назву групи, а другий стовпець - 
-- ModelsCount представляє результат функції Count, яка обчислює кількість рядків групи.

--Варто враховувати, що будь-який стовпець, який використовується у виразі SELECT 
--(не рахуючи стовпців, які зберігають результат агрегатних функцій), повинні бути вказані після оператора GROUP BY. 
--Так, наприклад, у разі вище стовпець Manufacturer зазначений і у виразі SELECT, і у виразі GROUP BY.

--І якщо у виразі SELECT проводиться вибірка по одному або декільком стовпцям і також використовуються агрегатні функції, 
--необхідно використовувати вираз GROUP BY. Так, наступний приклад працювати не буде, тому що він не містить виразу угруповання:

SELECT Manufacturer, COUNT(*) AS ModelsCount
FROM Products

--
SELECT Manufacturer, ProductCount, COUNT(*) AS ModelsCount
FROM Products
GROUP BY Manufacturer, ProductCount

--Оператор GROUP BYможе виконувати угруповання за безліччю стовпців.

--Якщо стовпець, за яким проводиться угруповання, містить значення NULL, то рядки зі значенням NULL становитимуть окрему групу.

--Слід враховувати, що вираз GROUP BYмає йти після виразу WHERE, але до виразу ORDER BY:

SELECT Manufacturer, COUNT(*) AS ModelsCount
FROM Products
WHERE Price > 30000
GROUP BY Manufacturer
ORDER BY ModelsCount DESC

--Фільтрування груп. HAVING
--Оператор HAVING визначає, які групи будуть включені у вихідний результат, тобто виконує фільтрацію груп.

--Застосування HAVING багато в чому аналогічне до застосування WHERE. 
--Тільки WHERE застосовується до фільтрації рядків, то HAVING використовується для фільтрації груп.

--Наприклад, знайдемо всі групи товарів за виробниками, для яких визначено понад 1 модель:

SELECT Manufacturer, COUNT(*) AS ModelsCount
FROM Products
GROUP BY Manufacturer
HAVING COUNT(*) > 1

-- При цьому в одній команді ми можемо використовувати вирази WHERE та HAVING:

SELECT Manufacturer, COUNT(*) AS ModelsCount
FROM Products
WHERE Price * ProductCount > 80000
GROUP BY Manufacturer
HAVING COUNT(*) > 1

--Тобто в даному випадку спочатку фільтруються рядки: вибираються ті товари, загальна вартість яких більша за 80000. 
--Потім вибрані товари групуються за виробниками. І далі фільтруються самі групи - вибираються ті групи, які містять понад 1 модель.

--Якщо при цьому необхідно провести сортування, вираз ORDER BY йде після виразу HAVING:

SELECT Manufacturer, COUNT(*) AS Models, SUM(ProductCount) AS Units
FROM Products
WHERE Price * ProductCount > 80000
GROUP BY Manufacturer
HAVING SUM(ProductCount) > 2
ORDER BY Units DESC

--В даному випадку угруповання йде по виробниках, а також вибирається кількість моделей для кожного виробника (Models) 
--та загальна кількість усіх товарів по всіх цих моделях (Units). Наприкінці групи сортуються за кількістю товарів зі спадання.

--------------
-- Розширення SQL Server для групування

-- Додатково до стандартних операторів GROUP BY і HAVING SQL Server 
-- підтримує ще чотири спеціальні розширення для групування даних: ROLLUP , CUBE , GROUPING SETS та OVER .

-- Оператор ROLLUP додає рядок, що підсумовує, в результуючий набір:

SELECT Manufacturer, COUNT(*) AS Models, SUM(ProductCount) AS Units
FROM Products
GROUP BY Manufacturer WITH ROLLUP

-- Альтернативний синтаксис запиту, який можна використовувати, починаючи з версії MS SQL Server 2008:

SELECT Manufacturer, COUNT(*) AS Models, SUM(ProductCount) AS Units
FROM Products
GROUP BY ROLLUP(Manufacturer)

-- При групуванні за кількома критеріями ROLLUP буде створювати підсумовуючий рядок для кожної з підгруп:

SELECT Manufacturer, COUNT(*) AS Models, SUM(ProductCount) AS Units
FROM Products
GROUP BY Manufacturer, ProductCount WITH ROLLUP

-- При сортуванні за допомогою ORDER BY слід враховувати, що воно застосовується вже після додавання рядка, що підсумовує.

-- CUBE схожий на ROLLUP за тим винятком, що CUBE додає підсумовують рядки для кожної комбінації груп.

SELECT Manufacturer, COUNT(*) AS Models, SUM(ProductCount) AS Units
FROM Products
GROUP BY Manufacturer, ProductCount WITH CUBE

-- Оператор GROUPING SETS аналогічно ROLLUP і CUBE додає сумуючий рядок для груп. Але при цьому він не включає самі групи:

SELECT Manufacturer, COUNT(*) AS Models, ProductCount
FROM Products
GROUP BY GROUPING SETS(Manufacturer, ProductCount)

-- При цьому його можна поєднувати з ROLLUP або CUBE. 
-- Наприклад, крім підсумовувальних рядків по кожній із груп додамо підсумовуючий рядок для всіх груп:

SELECT Manufacturer, COUNT(*) AS Models, 
        ProductCount, SUM(ProductCount) AS Units
FROM Products
GROUP BY GROUPING SETS(ROLLUP(Manufacturer), ProductCount)

-- За допомогою дужок можна визначити складніші сценарії угруповання:

SELECT Manufacturer, COUNT(*) AS Models, 
        ProductCount, SUM(ProductCount) AS Units
FROM Products
GROUP BY GROUPING SETS((Manufacturer, ProductCount), ProductCount)

-- Вираз OVER дозволяє підсумовувати дані, при цьому повертаючи рядки, які використовувалися для отримання сумованих даних. 
-- Наприклад, знайдемо кількість моделей та загальну кількість товарів цих моделей за виробником:

SELECT ProductName, Manufacturer, ProductCount,
        COUNT(*) OVER (PARTITION BY Manufacturer) AS Models,
        SUM(ProductCount) OVER (PARTITION BY Manufacturer) AS Units
FROM Products

--Вираз OVER ставиться після агрегатної функції, потім у дужках йде вираз PARTITION BY і стовпець, яким виконується угруповання.

--Тобто в даному випадку ми вибираємо назву моделі, виробника, 
--кількість одиниць моделі та додаємо до цього кількість моделей для даного виробника та загальну кількість одиниць усіх моделей виробника

