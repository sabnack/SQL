﻿------------------------------------------------------------
-- умови

--IF условие
--    {инструкция|BEGIN...END}
--[ELSE
--    {инструкция|BEGIN...END}]

---
CREATE TABLE Products
(
    Id INT IDENTITY PRIMARY KEY,
    ProductName NVARCHAR(30) NOT NULL,
    Manufacturer NVARCHAR(20) NOT NULL,
    ProductCount INT DEFAULT 0,
    Price MONEY NOT NULL
);
CREATE TABLE Customers
(
    Id INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(30) NOT NULL
);
CREATE TABLE Orders
(
    Id INT IDENTITY PRIMARY KEY,
    ProductId INT NOT NULL REFERENCES Products(Id) ON DELETE CASCADE,
    CustomerId INT NOT NULL REFERENCES Customers(Id) ON DELETE CASCADE,
    CreatedAt DATE NOT NULL,
    ProductCount INT DEFAULT 1,
    Price MONEY NOT NULL
);
-----
DECLARE @lastDate DATE
 
SELECT @lastDate = MAX(CreatedAt) FROM Orders
 
IF DATEDIFF(day, @lastDate, GETDATE()) > 10
	PRINT 'There have been no orders in the last ten days'

------
DECLARE @lastDate DATE
 
SELECT @lastDate = MAX(CreatedAt) FROM Orders
 
IF DATEDIFF(day, @lastDate, GETDATE()) > 10
	PRINT 'There have been no orders in the last ten days'
ELSE
    PRINT 'There have been orders in the last ten days'

-------
DECLARE @lastDate DATE, @count INT, @sum MONEY
 
SELECT @lastDate = MAX(CreatedAt), 
        @count = SUM(ProductCount) ,
        @sum = SUM(ProductCount * Price)
FROM Orders
 
IF @count > 0
    BEGIN
        PRINT 'Last order date: ' + CONVERT(NVARCHAR, @lastDate)
        PRINT 'Sold ' + CONVERT(NVARCHAR, @count) + ' unit(s)'
        PRINT 'Total amount ' + CONVERT(NVARCHAR, @sum)
    END;
ELSE
    PRINT 'There are no orders in the database'

-- Функція CASE перевіряє значення деякого виразу, і залежно від результату перевірки може повертати той чи інший результат.

--CASE выражение
--    WHEN значение_1 THEN результат_1
--    WHEN значение_2 THEN результат_2
--    .................................
--    WHEN значение_N THEN результат_N
--    [ELSE альтернативный_результат]
--END

---
CREATE TABLE Products
(
    Id INT IDENTITY PRIMARY KEY,
    ProductName NVARCHAR(30) NOT NULL,
    Manufacturer NVARCHAR(20) NOT NULL,
    ProductCount INT DEFAULT 0,
    Price MONEY NOT NULL
);

--
SELECT ProductName, Manufacturer,
    CASE ProductCount
        WHEN 1 THEN 'Товар заканчивается'
        WHEN 2 THEN 'Мало товара'
        WHEN 3 THEN 'Есть в наличии'
        ELSE 'Много товара'
    END AS EvaluateCount
FROM Products

-- Тут значення стовпця ProductCount послідовно порівнюється зі значеннями після операторів WHEN. 
--Залежно від значення стовпця ProductCount функція CASE повертатиме один із рядків, що йде після відповідного оператора THEN. 
--Для результату, що повертається, визначений стовпець EvaluateCount

-- Також функція CASE може набувати ще однієї форми:

--CASE
--    WHEN выражение_1 THEN результат_1
--    WHEN выражение_2 THEN результат_2
--    .................................
--    WHEN выражение_N THEN результат_N
--    [ELSE альтернативный_результат]
--END

--
SELECT ProductName, Manufacturer,
    CASE
        WHEN Price > 50000 THEN 'Категория A'
        WHEN Price BETWEEN 40000 AND 50000 THEN 'Категория B'
        WHEN Price BETWEEN 30000 AND 40000 THEN 'Категория C'
        ELSE 'Категория D'
    END AS Category
FROM Products

-- Фактично все те саме, що і в попередньому прикладі, тільки після CASE не вказується порівнюване значення. 
--А самі порівняння стоять після оператора WHEN. 
--І якщо вираз після оператора WHEN буде істинним, то повертається значення, яке йде після відповідного оператора THEN.

-- Функція IIF залежно від результату умовного виразу повертає одне із двох значень. Загальна форма функції виглядає так:
-- IIF(условие, значение_1, значение_2)

-- Якщо умова функції IIF істинно то повертається значення_1, якщо помилково, то повертається значення_2. Наприклад:
SELECT ProductName, Manufacturer,
    IIF(ProductCount>3, N'Много товара', N'Мало товара')
FROM Products

--------------------------------------------------------------------------
--Змінна є іменований об'єкт, який зберігає певне значення. Для визначення змінних застосовується вираз DECLARE, 
--після якого вказується назва та тип змінної. Назва локальної змінної повинна починатися з символу @:

--DECLARE @название_переменной тип_данных
--Наприклад, визначимо змінну name, яка матиме тип NVARCHAR:

DECLARE @name NVARCHAR(20)
--Також можна визначити через кому відразу кілька змінних:

DECLARE @name NVARCHAR(20), @age INT
--За допомогою виразу SET можна надати змінній деяке значення:

DECLARE @name NVARCHAR(20), @age INT;
SET @name='Tom';
SET @age = 18;
--Оскільки @name надає тип NVARCHAR, тобто рядок, то цій змінній відповідно і надається рядок. 
--А змінній @age присвоюється число, оскільки вона є типом INT.

--Вираз PRINT повертає повідомлення клієнту. Наприклад:

PRINT 'Hello World'
--І за його допомогою ми можемо вивести значення змінної:

DECLARE @name NVARCHAR(20), @age INT;
SET @name='Tom';
SET @age = 18;
PRINT 'Name: ' + @name;
PRINT 'Age: ' + CONVERT(CHAR, @age);

---
DECLARE @name NVARCHAR(20), @age INT;
SET @name='Tom';
SET @age = 18;
SELECT @name, @age;

--
DECLARE @maxPrice MONEY, 
    @minPrice MONEY, 
    @dif MONEY, 
    @count INT

SET @count = (SELECT SUM(ProductCount) FROM Orders);
 
SELECT @minPrice=MIN(Price), @maxPrice = MAX(Price) FROM Products
 
SET @dif = @maxPrice - @minPrice;
 
PRINT 'Total sold: ' + STR(@count, 5) + ' item(s)';
PRINT 'Difference between maximum and minimum price: ' + STR(@dif)

--
DECLARE @sum MONEY, @id INT, @prodid INT, @name NVARCHAR(20);
SET @id=2;
 
SELECT @sum = SUM(Orders.Price*Orders.ProductCount), 
     @name=Products.ProductName, @prodid = Products.Id
FROM Orders
INNER JOIN Products ON ProductId = Products.Id
GROUP BY Products.ProductName, Products.Id
HAVING Products.Id=@id
 
PRINT 'Item ' + @name + ' sold for the amount of ' + STR(@sum)

---------
-- Цикл

--WHILE условие
--    {инструкция|BEGIN...END}

---
DECLARE @number INT, @factorial INT
SET @factorial = 1;
SET @number = 5;
 
WHILE @number > 0
    BEGIN
        SET @factorial = @factorial * @number
        SET @number = @number - 1
    END;
 
PRINT @factorial

-------
DECLARE @number INT
SET @number = 1
 
WHILE @number < 10
    BEGIN
        PRINT CONVERT(NVARCHAR, @number)
        SET @number = @number + 1
        IF @number = 7
            BREAK;
        IF @number = 4
            CONTINUE;
        PRINT 'End'
    END;

-----------
-- Обробка помилок

--BEGIN TRY
--    инструкции
--END TRY
--BEGIN CATCH
--    инструкции
--END CATCH

--------
--У блоці CATCH для помилки ми можемо використовувати ряд функцій:

--ERROR_NUMBER() : повертає номер помилки

--ERROR_MESSAGE() : повертає повідомлення про помилку

--ERROR_SEVERITY() : повертає рівень серйозності помилки. 
--Ступінь серйозності становить числове значення. 
--І якщо воно дорівнює 10 і менше, то така помилка сприймається як попередження і обробляється конструкцією TRY...CATCH. 
--Якщо це значення дорівнює 20 і від, то така помилка призводить до закриття підключення до бази даних, 
--якщо вона обробляється конструкцією TRY...CATCH.

--ERROR_STATE() : повертає стан помилки

----------
CREATE TABLE Accounts (FirstName NVARCHAR NOT NULL, Age INT NOT NULL)
 
BEGIN TRY
    INSERT INTO Accounts VALUES(NULL, NULL)
    PRINT 'Data added successfully!'
END TRY
BEGIN CATCH
    PRINT 'Error ' + CONVERT(VARCHAR, ERROR_NUMBER()) + ':' + ERROR_MESSAGE()
END CATCH

----------------------
-- Табличні змінні

--DECLARE @табличная_переменная TABLE
--(столбец_1 тип_данных [атрибуты_столбца], 
-- столбец_2 тип_данных [атрибуты_столбца] ....)
-- [атрибуты_таблицы]

--
DECLARE @ABrends TABLE (ProductId INT,  ProductName NVARCHAR(20))
 
INSERT INTO @ABrends
VALUES(1, 'iPhone 8'),
(2, 'Samsumg Galaxy S8')
 
SELECT * FROM @ABrends

--
--Проте слід враховувати, що такі змінні в повному обсязі еквівалентні таблицям. 
--Вони живуть у межах одного пакета, після завершення роботи якого вони видаляються. 
--Тобто вони мають тимчасовий характер, і фізично їх дані ніде не зберігаються на жорсткому диску.

---------
-- Тимчасові локальні та глобальні таблиці

CREATE TABLE #ProductSummary
(ProdId INT IDENTITY,
ProdName NVARCHAR(20),
Price MONEY)
 
INSERT INTO #ProductSummary
VALUES ('Nokia 8', 18000),
        ('iPhone 8', 56000)
 
SELECT * FROM #ProductSummary

--
SELECT ProductId, 
        SUM(ProductCount) AS TotalCount, 
        SUM(ProductCount * Price) AS TotalSum
INTO #OrdersSummary
FROM Orders
GROUP BY ProductId

select * from #OrdersSummary
 
SELECT Products.ProductName, #OrdersSummary.TotalCount, #OrdersSummary.TotalSum
FROM Products
JOIN #OrdersSummary ON Products.Id = #OrdersSummary.ProductId

--
CREATE TABLE ##OrderDetails
(ProductId INT, TotalCount INT, TotalSum MONEY)
 
INSERT INTO ##OrderDetails
SELECT ProductId, SUM(ProductCount), SUM(ProductCount * Price)
FROM Orders
GROUP BY ProductId
 
SELECT * FROM ##OrderDetails

---
WITH OrdersInfo AS
(
    SELECT ProductId, 
        SUM(ProductCount) AS TotalCount, 
        SUM(ProductCount * Price) AS TotalSum
    FROM Orders
    GROUP BY ProductId
)
 
SELECT * FROM OrdersInfo -- ok
SELECT * FROM OrdersInfo -- error
SELECT * FROM OrdersInfo -- error

-- На відміну від тимчасових таблиць табличні виконання зберігаються в оперативній пам'яті і 
-- існують лише під час першого виконання запиту, який представляє цей табличний вираз.

--------------------------
--Views представляють віртуальні таблиці. 
--Але на відміну від стандартних таблиць у базі даних Views містять запити, які динамічно витягують використовувані дані.

--Уявлення дають нам низку переваг. 
--Вони полегшують комплексні SQL-операції. 
--Вони захищають дані, оскільки уявлення можуть дати доступом до частини таблиці, а чи не до таблиці. 
--Views також дозволяють повертати відформатовані значення з таблиць у потрібній та зручній формі.

--CREATE VIEW название_представления [(столбец_1, столбец_2, ....)]
--AS выражение_SELECT

----
CREATE TABLE Products
(
    Id INT IDENTITY PRIMARY KEY,
    ProductName NVARCHAR(30) NOT NULL,
    Manufacturer NVARCHAR(20) NOT NULL,
    ProductCount INT DEFAULT 0,
    Price MONEY NOT NULL
);
CREATE TABLE Customers
(
    Id INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(30) NOT NULL
);
CREATE TABLE Orders
(
    Id INT IDENTITY PRIMARY KEY,
    ProductId INT NOT NULL REFERENCES Products(Id) ON DELETE CASCADE,
    CustomerId INT NOT NULL REFERENCES Customers(Id) ON DELETE CASCADE,
    CreatedAt DATE NOT NULL,
    ProductCount INT DEFAULT 1,
    Price MONEY NOT NULL
);
----
CREATE VIEW OrdersProductsCustomers AS
SELECT Orders.CreatedAt AS OrderDate, 
        Customers.FirstName AS Customer,
        Products.ProductName As Product  
FROM Orders INNER JOIN Products ON Orders.ProductId = Products.Id
INNER JOIN Customers ON Orders.CustomerId = Customers.Id

--
SELECT * FROM OrdersProductsCustomers

----
--Під час створення уявлень слід враховувати, що уявлення, як і таблиці, повинні мати унікальні імена у межах тієї ж бази даних.

--Уявлення може мати трохи більше 1024 стовпців і можуть звертатися лише до 256 таблицям.

--Також можна створювати уявлення на основі інших уявлень. Такі уявлення ще називають вкладеними (nested views). 
--Однак рівень вкладеності не може бути більше 32-х.

--Команда SELECT , що використовується у уявленнi, не може включати вирази INTO або ORDER BY 
--(за винятком тих випадків, коли також застосовується вираз TOP або OFFSET ). 
--Якщо ж необхідне сортування даних у уявленнi, то вираз ORDER BY застосовується у команді SELECT, яка отримує дані з уявлення.

CREATE VIEW OrdersProductsCustomers2 (OrderDate, Customer,Product)
AS SELECT Orders.CreatedAt,
        Customers.FirstName,
        Products.ProductName
FROM Orders INNER JOIN Products ON Orders.ProductId = Products.Id
INNER JOIN Customers ON Orders.CustomerId = Customers.Id

---
-- Зміна уявлення

--ALTER VIEW название_представления [(столбец_1, столбец_2, ....)]
--AS выражение_SELECT

--
ALTER VIEW OrdersProductsCustomers
AS SELECT Orders.CreatedAt AS OrderDate, 
        Customers.FirstName AS Customer,
        Products.ProductName AS Product,
        Products.Manufacturer AS Manufacturer
FROM Orders INNER JOIN Products ON Orders.ProductId = Products.Id
INNER JOIN Customers ON Orders.CustomerId = Customers.Id

--
-- Видалення уявлення

-- 	
DROP VIEW OrdersProductsCustomers

-- Також варто відзначити, що при видаленні таблиць слід видалити і уявлення, які використовують ці таблиці.

-----------------
--View можуть бути оновлюваними (updatable). У таких View ми можемо змінити або видалити рядки або додати нові рядки.

--При створенні подібних View є багато обмежень. 
--Зокрема, команда SELECT при створенні View, що оновлюється, не може містити:

--TOP

--DISTINCT

--UNION

--JOIN

--агрегатні функції типу COUNT чи MAX

--GROUP BY и HAVING

--підзапити

--похідні стовпці або стовпці, які обчислюються на підставі кількох значень

--звернення одночасно до кількох таблиць

--Варто зазначити, що це стосується саме View, що оновлюється. 
--Наприклад, для створення звичайної View ми можемо використовувати в команді SELECT оператор JOIN, 
--однак така View не буде оновлюваною. 
--При спробі його оновити, ми будемо отримувати помилку виду "View or function name_name is not 
--updatable because the modification affects multiple base tables."

--
CREATE TABLE Products
(
    Id INT IDENTITY PRIMARY KEY,
    ProductName NVARCHAR(30) NOT NULL,
    Manufacturer NVARCHAR(20) NOT NULL,
    ProductCount INT DEFAULT 0,
    Price MONEY NOT NULL
)
--

CREATE VIEW ProductView
AS SELECT ProductName AS Product, Manufacturer, Price
FROM Products

--
INSERT INTO ProductView (Product, Manufacturer, Price)
VALUES('Nokia 8', 'HDC Global', 18000)
 
SELECT * FROM ProductView

--Варто зазначити, що при додаванні фактично буде додано об'єкт у таблицю Products, яку використовує представлення ProductView. 
--І тому треба враховувати, що якщо в цій таблиці є якісь стовпці, в які View не додає дані, 
--але які не допускають значення NULL або не підтримують значення за замовчуванням, то додавання завершиться з помилкою.

--
UPDATE ProductView 
SET Price= 15000 WHERE Product='Nokia 8'

--
DELETE FROM ProductView 
WHERE Product='Nokia 8'

-- Оновлення та видалення також зачіпають ту таблицю, яку використовує уявлення.
----------------------
--------------------------
-- Збережені процедури

--Нерідко операція з даними представляє набір інструкцій, які необхідно виконати у певній послідовності. 
--Наприклад, при додаванні даних купівлі товару необхідно внести дані до таблиці замовлень. 
--Однак перед цим треба перевірити, а чи є товар, що купується в наявності. 
--Можливо, при цьому доведеться перевірити ще низку додаткових умов. 
--Тобто фактично процес купівлі товару охоплює кілька дій, які мають виконуватись у певній послідовності. 
--І в цьому випадку більш оптимально буде інкапсулювати всі ці дії в один об'єкт - процедуру, що зберігається (stored procedure).

--Тобто по суті процедури, що зберігаються, представляють набір інструкцій, які виконуються як єдине ціле. 
--Тим самим процедури, що зберігаються, дозволяють спростити комплексні операції і винести їх в єдиний об'єкт. 
--Зміниться процес купівлі товару, відповідно достатньо змінити код процедури. Тобто процедура також спрощує керування кодом.

--Також процедури, що зберігаються, дозволяють обмежити доступ до даних у таблицях і тим самим зменшити 
--ймовірність навмисних або неусвідомлених небажаних дій щодо цих даних.

--І ще один важливий аспект – продуктивність. Збережені процедури зазвичай виконуються швидше, ніж звичайні SQL-інструкції. 
--Все тому, що код процедур компілюється один раз при першому її запуску, а потім зберігається в скомпільованій формі.

--Для створення процедури , що зберігається застосовується команда CREATE PROCEDURE або CREATE PROC .

--Таким чином, процедура, що зберігається, має три ключові особливості: спрощення коду, безпека і продуктивність.

CREATE TABLE Products
(
    Id INT IDENTITY PRIMARY KEY,
    ProductName NVARCHAR(30) NOT NULL,
    Manufacturer NVARCHAR(20) NOT NULL,
    ProductCount INT DEFAULT 0,
    Price MONEY NOT NULL
);

----
CREATE PROCEDURE ProductSummary AS
SELECT ProductName AS Product, Manufacturer, Price
FROM Products

-------
CREATE PROCEDURE ProductSummary AS
BEGIN
    SELECT ProductName AS Product, Manufacturer, Price
    FROM Products
END;

----------
EXEC ProductSummary

---------
DROP PROCEDURE ProductSummary

---------------------------
-- Параметри у процедурах

CREATE PROCEDURE AddProduct
    @name NVARCHAR(20),
    @manufacturer NVARCHAR(20),
    @count INT,
    @price MONEY
AS
INSERT INTO Products(ProductName, Manufacturer, ProductCount, Price) 
VALUES(@name, @manufacturer, @count, @price)

--
DECLARE @prodName NVARCHAR(20), @company NVARCHAR(20);
DECLARE @prodCount INT, @price MONEY
SET @prodName = 'Galaxy C7'
SET @company = 'Samsung'
SET @price = 22000
SET @prodCount = 5
 
EXEC AddProduct @prodName, @company, @prodCount, @price
 
SELECT * FROM Products

-------------

EXEC AddProduct 'Galaxy C7', 'Samsung', 5, 22000

------------
DECLARE @prodName NVARCHAR(20), @company NVARCHAR(20);
SET @prodName = 'Honor 9'
SET @company = 'Huawei'
 
EXEC AddProduct @name = @prodName, 
                @manufacturer=@company,
                @count = 3, 
                @price = 18000

---------
CREATE PROCEDURE AddProductWithOptionalCount
    @name NVARCHAR(20),
    @manufacturer NVARCHAR(20),
    @price MONEY,
    @count INT = 1
AS
INSERT INTO Products(ProductName, Manufacturer, ProductCount, Price) 
VALUES(@name, @manufacturer, @count, @price)

--
DECLARE @prodName NVARCHAR(20), @company NVARCHAR(20), @price MONEY
SET @prodName = 'Redmi Note 5A'
SET @company = 'Xiaomi'
SET @price = 22000
 
EXEC AddProductWithOptionalCount @prodName, @company, @price
 
SELECT * FROM Products

----------------------
-- Вихідні параметри та повернення результату

CREATE PROCEDURE GetPriceStats
    @minPrice MONEY OUTPUT,
    @maxPrice MONEY OUTPUT
AS
SELECT @minPrice = MIN(Price),  @maxPrice = MAX(Price)
FROM Products

--
DECLARE @minPrice MONEY, @maxPrice MONEY
 
EXEC GetPriceStats @minPrice OUTPUT, @maxPrice OUTPUT
 
PRINT 'Minimum price ' + CONVERT(VARCHAR, @minPrice)
PRINT 'Maximum price ' + CONVERT(VARCHAR, @maxPrice)

--------
CREATE PROCEDURE CreateProduct
    @name NVARCHAR(20),
    @manufacturer NVARCHAR(20),
    @count INT,
    @price MONEY,
    @id INT OUTPUT
AS
    INSERT INTO Products(ProductName, Manufacturer, ProductCount, Price)
    VALUES(@name, @manufacturer, @count, @price)
    SET @id = @@IDENTITY

--
DECLARE @id INT
 
EXEC CreateProduct 'LG V30', 'LG', 3, 28000, @id OUTPUT
 
PRINT @id

SELECT * FROM Products

-----------
CREATE PROCEDURE GetAvgPrice AS
DECLARE @avgPrice MONEY
SELECT @avgPrice = AVG(Price)
FROM Products
RETURN @avgPrice;

--
DECLARE @result MONEY
 
EXEC @result = GetAvgPrice
PRINT @result

-- Варто відзначити, що RETURN повертає лише цілі чисельні значення.
----------------
-- https://learn.microsoft.com/ru-ru/sql/relational-databases/user-defined-functions/user-defined-functions?view=sql-server-ver16

CREATE FUNCTION east_or_west (
	@long DECIMAL(9,6)
)
RETURNS CHAR(4) AS
BEGIN
	DECLARE @return_value CHAR(4);
	SET @return_value = 'same';
    IF (@long > 0.00) SET @return_value = 'east';
    IF (@long < 0.00) SET @return_value = 'west';
 
    RETURN @return_value
END;

SELECT dbo.east_or_west(0) AS argument_0, dbo.east_or_west(-1) AS argument_minus_1, dbo.east_or_west(1) AS argument_plus_1;

--------------
-- https://blog.devgenius.io/views-vs-functions-vs-procedures-sql-91f2e16d0546
-- https://bertwagner.com/posts/sql-server-stored-procedures-vs-functions-vs-views/
-- https://www.mssqltips.com/sqlservertip/7437/sql-stored-procedures-views-functions-examples/
-- https://www.dotnettricks.com/learn/sqlserver/difference-between-stored-procedure-and-function-in-sql-server#:~:text=The%20function%20must%20return%20a,be%20called%20from%20a%20Function.

--------------
-- Дополнительные примеры по SQL Joins

-- Создание базы данных
CREATE DATABASE MyMultiTableDatabase;
GO
-- Использование созданной базы данных
USE MyMultiTableDatabase;
GO
-- Создание таблицы "Сотрудники" (Employees)
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    DepartmentID INT
);

-- Заполнение таблицы "Сотрудники" данными
INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID)
VALUES
    (1, 'John', 'Smith', 101),
    (2, 'Alice', 'Johnson', 102),
    (3, 'Michael', 'Brown', 101),
    (4, 'Olga', 'Petrova', 103),
    (5, 'David', 'Lee', 102);

-- Создание таблицы "Отделы" (Departments)
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(50)
);

-- Заполнение таблицы "Отделы" данными
INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES
    (101, 'HR'),
    (102, 'IT'),
    (103, 'Finance'),
    (104, 'Marketing'),
    (105, 'Operations');

-- Создание таблицы "Продукты" (Products)
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    CategoryID INT
);

-- Заполнение таблицы "Продукты" данными
INSERT INTO Products (ProductID, ProductName, CategoryID)
VALUES
    (1001, 'Laptop', 201),
    (1002, 'Printer', 202),
    (1003, 'Monitor', 201),
    (1004, 'Keyboard', 202),
    (1005, 'Mouse', 202);

-- Создание таблицы "Категории продуктов" (ProductCategories)
CREATE TABLE ProductCategories (
    CategoryID INT PRIMARY KEY,
    CategoryName NVARCHAR(50)
);

-- Заполнение таблицы "Категории продуктов" данными
INSERT INTO ProductCategories (CategoryID, CategoryName)
VALUES
    (201, 'Electronics'),
    (202, 'Office Supplies'),
    (203, 'Furniture'),
    (204, 'Software'),
    (205, 'Accessories');

-- Создание таблицы "Заказы" (Orders)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);

-- Заполнение таблицы "Заказы" данными
INSERT INTO Orders (OrderID, CustomerID, OrderDate)
VALUES
    (5001, 1001, '2024-05-16'),
    (5002, 1002, '2024-05-17'),
    (5003, 1003, '2024-05-18'),
    (5004, 1004, '2024-05-19'),
    (5005, 1005, '2024-05-20');

-------------------------------------
--INNER JOIN: Получить список всех сотрудников и их отделов:
SELECT E.FirstName, E.LastName, D.DepartmentName
FROM Employees AS E
INNER JOIN Departments AS D ON E.DepartmentID = D.DepartmentID;

--LEFT JOIN: Найти отделы, в которых есть сотрудники, и отделы, в которых нет сотрудников:
SELECT D.DepartmentName, E.FirstName
FROM Departments AS D
LEFT JOIN Employees AS E ON D.DepartmentID = E.DepartmentID;

--RIGHT JOIN: Найти сотрудников, которые принадлежат к отделам, и сотрудников, которые не принадлежат ни к одному отделу:
SELECT E.FirstName, D.DepartmentName
FROM Employees AS E
RIGHT JOIN Departments AS D ON E.DepartmentID = D.DepartmentID;

--FULL OUTER JOIN: Получить список всех сотрудников и всех отделов:
SELECT E.FirstName, D.DepartmentName
FROM Employees AS E
FULL OUTER JOIN Departments AS D ON E.DepartmentID = D.DepartmentID;

--SELF JOIN: Найти всех сотрудников, у которых есть общий отдел:
SELECT E1.FirstName, E2.FirstName AS SharedColleague
FROM Employees AS E1
INNER JOIN Employees AS E2 ON E1.DepartmentID = E2.DepartmentID
WHERE E1.EmployeeID <> E2.EmployeeID;

--CROSS JOIN: Получить все возможные комбинации продуктов и категорий:
SELECT P.ProductName, PC.CategoryName
FROM Products AS P
CROSS JOIN ProductCategories AS PC;

--SELF JOIN с условием: Найти сотрудников, у которых есть общий отдел, и они не являются одним и тем же сотрудником:
SELECT E1.FirstName, E2.FirstName AS SharedColleague
FROM Employees AS E1
INNER JOIN Employees AS E2 ON E1.DepartmentID = E2.DepartmentID
WHERE E1.EmployeeID <> E2.EmployeeID;

--INNER JOIN с агрегацией: Получить средний возраст сотрудников в каждом отделе:
SELECT D.DepartmentName, AVG(YEAR(GETDATE()) - YEAR(BirthDate)) AS AvgAge
FROM Employees AS E
INNER JOIN Departments AS D ON E.DepartmentID = D.DepartmentID
GROUP BY D.DepartmentName;

--LEFT JOIN с условием: Найти отделы, в которых есть сотрудники, и общее количество сотрудников для каждого отдела:
SELECT D.DepartmentName, COUNT(E.EmployeeID) AS TotalEmployees
FROM Departments AS D
LEFT JOIN Employees AS E ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentName;

--INNER JOIN с несколькими таблицами: Получить список продуктов в каждом заказе:
SELECT O.OrderID, P.ProductName
FROM Orders AS O
INNER JOIN OrderDetails AS OD ON O.OrderID = OD.OrderID
INNER JOIN Products AS P ON OD.ProductID = P.ProductID;
