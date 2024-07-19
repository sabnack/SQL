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

--------------

-- Тригери

--Тригери представляють спеціальний тип процедури, що зберігається, 
--яка викликається автоматично при виконанні певної дії над таблицею або поданням, зокрема, при додаванні, 
--зміні або видаленні даних, тобто при виконанні команд INSERT, UPDATE, DELETE.

--CREATE TRIGGER имя_триггера
--ON {имя_таблицы | имя_представления}
--{AFTER | INSTEAD OF} [INSERT | UPDATE | DELETE]
--AS выражения_sql

--Для створення тригера застосовується вираз CREATE TRIGGER , після якого йде ім'я тригера. Як правило, 
--ім'я тригера відображає тип операцій та ім'я таблиці, над якою проводиться операція.

--Кожен тригер асоціюється з певною таблицею або уявленням, ім'я яких вказується після ON .

--Потім встановлюється тип тригера. Ми можемо використовувати один із двох типів:

--AFTER : виконується після виконання дії. Визначається лише для таблиць.

--INSTEAD OF : виконується замість дії (тобто, по суті, дія - додавання, зміна або видалення - взагалі не виконується).
--Визначається для таблиць та уявлень

--Після типу тригера йде вказівка ​​операції, на яку визначається тригер: INSERT , UPDATE чи DELETE .

--Для тригера AFTER можна застосовувати відразу кілька дій, наприклад, UPDATE і INSERT. І тут операції вказуються через кому. 
--Для тригера INSTEAD OF можна визначити лише одну дію.

--І потім після слова AS йде набір виразів SQL, які і складають тіло тригера.

----------
CREATE TRIGGER Products_INSERT_UPDATE
ON Products
AFTER INSERT, UPDATE
AS
UPDATE Products
SET Price = Price + Price * 0.38
WHERE Id = (SELECT Id FROM inserted)

--
insert into Products (ProductName, Manufacturer, ProductCount, Price)
values('Iphone 15', 'Apple', 11, 1111)

select * from Products

----------
DISABLE TRIGGER Products_INSERT_UPDATE ON Products
----------
ENABLE TRIGGER Products_INSERT_UPDATE ON Products
----------
DROP TRIGGER Products_INSERT_UPDATE

----------
CREATE TABLE Products
(
    Id INT IDENTITY PRIMARY KEY,
    ProductName NVARCHAR(30) NOT NULL,
    Manufacturer NVARCHAR(20) NOT NULL,
    ProductCount INT DEFAULT 0,
    Price MONEY NOT NULL,
	IsDeleted bit default 0
);
CREATE TABLE History 
(
    Id INT IDENTITY PRIMARY KEY,
    ProductId INT NOT NULL,
    Operation NVARCHAR(200) NOT NULL,
    CreateAt DATETIME NOT NULL DEFAULT GETDATE(),
);
---------
CREATE TRIGGER Products_INSERT
ON Products
AFTER INSERT
AS
INSERT INTO History (ProductId, Operation)
SELECT Id, 'Added product ' + ProductName + '   Manufacturer ' + Manufacturer
FROM INSERTED
--
INSERT INTO Products (ProductName, Manufacturer, ProductCount, Price)
VALUES('iPhone X', 'Apple', 2, 79900)
 
SELECT * FROM History
select * from Products

--
CREATE TRIGGER Products_DELETE
ON Products
AFTER DELETE
AS
INSERT INTO History (ProductId, Operation)
SELECT Id, 'Deleted product ' + ProductName + '   Manufacturer ' + Manufacturer
FROM DELETED

--
DELETE FROM Products
WHERE Id=3
 
SELECT * FROM History

-----
CREATE TRIGGER Products_UPDATE
ON Products
AFTER UPDATE
AS
INSERT INTO History (ProductId, Operation)
SELECT Id, 'Updated product ' + ProductName + '   Manufacturer ' + Manufacturer
FROM INSERTED

----------------
--Тригер INSTEAD OF спрацьовує замість операції із даними. 
--Він визначається в принципі також, як тригер AFTER, за винятком, 
--що він може визначатися тільки для однієї операції - INSERT, DELETE або UPDATE. 
--І він може застосовуватися як таблиць, так представлень (тригер AFTER застосовується лише таблиць).

CREATE TRIGGER products_delete
ON Products
INSTEAD OF DELETE
AS
UPDATE Products
SET IsDeleted = 1
WHERE ID =(SELECT Id FROM deleted)

--
INSERT INTO Products(ProductName, Manufacturer, Price)
VALUES ('iPhone X', 'Apple', 79000),
('Pixel 2', 'Google', 60000);
 
DELETE FROM Products 
WHERE ProductName='Pixel 2';
 
SELECT * FROM Products;

-- Дополнительные примеры разных видов триггеров:

-- 1. Установка триггера FOR UPDATE
create trigger tr1
on Books
for update
as 
	select 'Было изменено', @@rowcount, ' записей'

go

update books
set books.quantity=books.quantity+5
where press like '%BHV%'

-- 2. Установка триггера FOR INSERT
create trigger tr2
on books
after insert
as
declare @InsDate int
select @InsDate=YearPress from inserted
if (Year(getdate()) - @InsDate > 10)

begin
	select 'Это слишком старая книга!'
	rollback transaction
end
else
begin
	print('Запись успешно вставлена в таблицу!')
end
go

insert into books (name, pages, yearpress, themes, author, press, comment, quantity )
values ('С++Базовый курс', 620, 1999, 'Программирование', 'Шилдт', 'Вильямс', '3-е издание', 2)
--Инструкции ROLLBACK TRANSACTION в триггерах уничтожают пакет, содержащий инструкцию, вызвавшую триггер.
--Последующие инструкции в пакете не выполняются.
go
insert into books (name, pages, yearpress, themes, author, press, comment, quantity )
values ('SQL', 1000, 2015, 'Энциклопедия SQL', 'Грофф', 'Питер', '3-е издание', 2)
go

-- 3. Установка триггера AFTER DELETE. Запрет на удаление
create trigger tr3 on books after delete
as
if(select count(*) from deleted where Name like '%SQL%')>0
begin
print 'Книгу по SQL удалять нельзя!'
rollback transaction
end

go

delete from books where Name like '%SQL%'

-- 4. Установка триггера AFTER DELETE. Подсчёт удаленных записей
disable trigger tr3 on books
go
create trigger tr4
on books after delete
as
declare @t int
select @t=count(*) from deleted
print 'Число удаленных записей: '+cast(@t as nvarchar(5))

go

delete from books where Id > 18

-- 5. Установка триггера AFTER UPDATE. Запрет на обновление
create trigger tr5 on books after update
as
if(select count(*) from deleted where Quantity=1)>0
begin
print 'Запрет на обновление!'
rollback transaction
end
go

update books set Quantity=10 where Quantity = 1
go
update books set Quantity=10 where Quantity = 2
go

-- 6. Установка триггера FOR UPDATE. Подсчёт обновленных записей
create trigger tr6
on Books
for update
as
declare @t int
select @t=count(*) from inserted
print 'Число обновленных записей: '+cast(@t as varchar(5))

go

update books set Quantity=10 where Quantity > 1

-- 7. Установка триггера INSTEAD OF DELETE
create trigger tr7 on books
instead of delete
as
print 'Запрет на удаление записей!'
go
delete from books where id = 11

-- 8. Установка триггера INSTEAD OF INSERT
create trigger tr8 on books
instead of insert
as
declare @var int 
select @var = count (*) from inserted where pages > 500
if (@var>0)
	begin 
		print 'Запрет на вставку: слишком много страниц :)'
	end
else	
	insert into books (name, pages, yearpress, themes, author, press, comment, quantity) 
	select name, pages, yearpress, themes, author, press, comment, quantity  from inserted

go

insert into books (name, pages, yearpress, themes, author, press, comment, quantity )
values ('С++Базовый курс', 600, 2010, 'Программирование', 'Шилдт', 'Вильямс', '3-е издание', 2)
insert into books (name, pages, yearpress, themes, author, press, comment, quantity)
values ('С++Базовый курс', 400, 2010, 'Программирование', 'Шилдт', 'Вильямс', '3-е издание', 2)
go

-- 9. Установка DDL-триггера на уровне БД
create trigger NotAlterDropTable 
on database
for ALTER_TABLE, DROP_TABLE
as
begin
print 'Нельзя удалять или изменять таблицы!'
rollback transaction
end

go

drop table books

drop trigger NotAlterDropTable on database

-- 10. Установка DDL-триггера на уровне сервера
create trigger NotAlterDropTableOnServer 
on all server
for ALTER_TABLE, DROP_TABLE
as
begin
print 'Нельзя удалять или изменять таблицы!'
rollback
end

go

drop table books

drop trigger NotAlterDropTableOnServer on all server

--------------------

-- Транзакции:

CREATE DATABASE [books]
GO
USE [books]
GO
CREATE TABLE [dbo].[books](
	[N] [int] IDENTITY(1,1) NOT NULL,
	[Code] [float] NULL,
	[New] [bit] NULL,
	[Name] [nvarchar](255) NULL,
	[Price] [money] NULL,
	[Izd] [nvarchar](255) NULL,
	[Pages] [float] NULL,
	[Format] [nvarchar](255) NULL,
	[Date] [datetime] NULL,
	[Pressrun] [float] NULL,
	[Themes] [nvarchar](255) NULL,
	[Category] [nvarchar](255) NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[books] ON 
INSERT [dbo].[books] ([N], [Code], [New], [Name], [Price], [Izd], [Pages], [Format], [Date], [Pressrun], [Themes], [Category]) VALUES 
(1, 4704, 0, N'Самоучитель работы на персональном компьютере: 3е изд., доп.', 17.4000, N'BHV Киев', 640, N'70х100/16', CAST(0x00008EE100000000 AS DateTime), 10000, N'Использование ПК в целом', N'Учебники'),
(2, 5110, 0, N'Аппаратные средства мультимедия. Видеосистема РС', 15.5100, N'BHV С.-Петербург', 400, N'70х100/16', CAST(0x00008F7900000000 AS DateTime), 5000, N'Использование ПК в целом', N'Учебники'),
(3, 4316, 0, N'Основы работы на ПК', 19.9100, N'BHV С.-Петербург', 440, N'70х100/16', CAST(0x00008EB600000000 AS DateTime), 3000, N'Использование ПК в целом', N'Учебники'),
(4, 5516, 0, N'Iнформатика-7. Експерементальний навчальний посiбник для учнiв 7 класу', 9.0000, N'DiaSoft', 208, N'70х100/16', CAST(0x00008FE900000000 AS DateTime), 2000, N'Использование ПК в целом', N'Учебники'),
(5, 4043, 1, N'Работа на персональном компьютере. Самоучитель', 19.0000, N'DiaSoft', 584, N'84х108/16', CAST(0x00008E1700000000 AS DateTime), 3000, N'Использование ПК в целом', N'Учебники'),
(6, 5228, 0, N'Толковый словарь компьютерных технологий', 29.0000, N'DiaSoft', 720, N'70х100/16', CAST(0x00008FD600000000 AS DateTime), 2000, N'Использование ПК в целом', N'Учебники'),
(7, 4756, 0, N'Основи iнформатики Екзаменацiйнi бiлети:запитання та вiдповiдi', 5.0000, N'DiaSoft UP', 160, N'84х108/16', NULL, 0, N'Использование ПК в целом', N'Учебники'),
(8, 4985, 0, N'Освой самостоятельно модернизацию и ремонт ПК за 24 часа, 2-е изд.', 18.9000, N'Вильямс', 288, N'70х100/16', CAST(0x00008F6800000000 AS DateTime), 5000, N'Использование ПК в целом', N'Учебники'),
(9, 5141, 0, N'Структуры данных и алгоритмы.', 37.8000, N'Вильямс', 384, N'70х100/16', CAST(0x00008FBC00000000 AS DateTime), 5000, N'Использование ПК в целом', N'Учебники'),
(10, 3055, 0, N'Новейший самоучитель работы на компьютере', 18.4800, N'ДЭСС', 654, N'70х100\16', CAST(0x00008CC500000000 AS DateTime), 10000, N'Использование ПК в целом', N'Учебники'),
(11, 4712, 0, N'Новейший самоучитель по работе в Интернет', 19.2900, N'ДЭСС', 528, N'70х100/16', CAST(0x00008EFC00000000 AS DateTime), 10000, N'Использование ПК в целом', N'Учебники'),
(12, 4241, 0, N'ПК для "чайников",7 е издание', 13.2000, N'Диалектика', 318, N'70х100/16', CAST(0x00008E8500000000 AS DateTime), 5000, N'Использование ПК в целом', N'Учебники'),
(13, 1395, 0, N'Информатика часть 4. Теоретическая информатика.', 5.9500, N'Диалог-МИФИ', 224, N'60х84\16', CAST(0x00008C3100000000 AS DateTime), 1000, N'Использование ПК в целом', N'Учебники'),
(14, 696, 0, N'IBM PC для пользователя. Краткий курс', 12.0000, N'Инфра-М', 480, N'60х90/16', CAST(0x00008BD600000000 AS DateTime), 50000, N'Использование ПК в целом', N'Учебники')
SET IDENTITY_INSERT [dbo].[books] OFF

-----
-- 1. Автоматическая транзакция

insert into books (Code, New, Name, Price, Izd, Pages, Format, Date, Pressrun, Themes, Category)
values(8882,1,'Test2',125.23,'test_izd',550,'test_format', 2005-08-30,12501,'test_themes','test_category')

--Atomicity (атомарность)
--Атомарность гарантирует, что никакая транзакция не будет зафиксирована в системе частично. 
--Будут либо выполнены все её подоперации, либо не выполнено ни одной.

--Consistency (согласованность)
--В соответствии с этим требованием, система находится в согласованном состоянии до начала транзакции 
--и должна остаться в согласованном состоянии после завершения транзакции. 

--Isolation (изолированность)
--Во время выполнения транзакции параллельные транзакции не должны оказывать влияние на её результат.

--Durability (долговременность, устойчивость)
--Независимо от проблем на нижних уровнях (к примеру, обесточивание системы или сбои в оборудовании), 
--изменения, сделанные успешно завершённой транзакцией, должны остаться сохранёнными после возвращения системы в работу.

-- 2. Пример явной транзакции

begin transaction
begin try
		--SET IDENTITY_INSERT [dbo].[books] ON
		insert into books (Code, New, Name, Price, Izd, Pages, Format, Date, Pressrun, Themes, Category)
		values(8899,0,N'Проверка работы транзакции',520,'Test2',120,'20x20/15',
				'01.04.1990',1,N'Использование транзакций',N'транзакции')
		insert into books (N, Code, New, Name, Price, Izd, Pages, Format, Date, Pressrun, Themes, Category)
		values(784, 8899,0,N'Проверка работы транзакции',520,'Test1',120,'20x20/15',
				'01.03.1990',1,N'Использование транзакций',N'транзакции')
		select * from books Where Name = N'Проверка работы транзакции'
		commit Transaction
		--SET IDENTITY_INSERT [dbo].[books] OFF
end try
begin catch
		 print N'Ошибка при выполнении транзакции!'
		 rollback transaction
end catch

-- 3. Использование системной переменной ERROR

begin transaction
--SET IDENTITY_INSERT [dbo].[books] ON
insert into books (N, Code, New, Name, Price, Izd, Pages, Format, Date, Pressrun, Themes, Category)
values(800, 8899, 10,N'Проверка работы транзакции',520,'Test',120,'20x20/15','05.03.2009',1,N'Использование транзакций',N'транзакции')
--SET IDENTITY_INSERT [dbo].[books] OFF
declare @ErrorNum int 
set @ErrorNum = @@ERROR
if @ErrorNum<>0
	begin
		print CAST(@ErrorNum as nvarchar(10))+ N': Cannot insert explicit value for identity column in table ''books'' when IDENTITY_INSERT is set to OFF.'
		print @@TRANCOUNT
		--@@TRANCOUNT возвращает число инструкций BEGIN TRANSACTION, выполненных в текущем соединении.
		rollback transaction
	end
else
	begin
		select * from books where Name = N'Проверка работы транзакции'
		print @@TRANCOUNT
		commit transaction
	end

print @@TRANCOUNT

-- 4. Установка точки сохранения

begin transaction

insert into books (name, new, price) values ('Test1', 1, 12.53)

save transaction savepoint1

insert into books (name, new, price) values ('Test2', 1, 12.53)

insert into books (N, name, new, price) values (790, 'Test3', 1, 12.53)

declare @ErrorNum int 
set @ErrorNum = @@ERROR

if @ErrorNum<>0
	begin
		print CAST(@ErrorNum as nvarchar(10))+ N': Cannot insert explicit value for identity column in table ''books'' when IDENTITY_INSERT is set to OFF.'
		print @@TRANCOUNT
		--@@TRANCOUNT возвращает число инструкций BEGIN TRANSACTION, выполненных в текущем соединении.
		rollback transaction savepoint1
	end
commit transaction

print @@TRANCOUNT
select * from books where Name like 'Test%'

-- 5. Включение механизма неявных транзакций

set implicit_transactions ON
print @@TRANCOUNT
insert into books (name, new, price) values ('Test2', 1, 12.53)
select * from books where Name like 'Test%'
print @@TRANCOUNT
commit transaction
print @@TRANCOUNT

-- 6. Использование транзакций в хранимых процедурах

create database UNIVERSITY
go

use UNIVERSITY
create table FACULTY
       (FacPK     integer      not null identity(1,1) constraint fac_prk primary key,
        Name      nvarchar(30) not null constraint fac_unq_nam unique ,
        Dean      nvarchar(20)  constraint fac_unq_den unique,
        Building  nchar(5),
        Fund      numeric(7, 2)  constraint fac_chk_fnd check (Fund > 0))

create table DEPARTMENT
       (DepPK     integer    not null identity(1,1) constraint dep_prk primary key,
        FacFK     integer     not null constraint dep_frk_fac references FACULTY(FacPK) on delete cascade,
        Name      nvarchar(30)  not null,
        Head      nvarchar(20),
        Building  nchar(5),
        Fund      numeric(7, 2) constraint dep_chk_fnd check (Fund > 0),
        constraint dep_unq_nam_frk unique (Name, FacFK))
		
go

insert into FACULTY (Name, Dean, Building, Fund) 
values (N'информатика', N'Сидоров', '6', 25000)
insert into FACULTY (Name, Dean, Building, Fund) 
values (N'кибернетика', N'Петров', '5', 27000)
insert into FACULTY (Name, Dean, Building, Fund) 
values (N'математика', N'Игнатов', '3', 23000)
go

create procedure AddDepartment @Faculty nvarchar(255), @Name nvarchar(255), 
@Head nvarchar(255), @Building int, @Fund numeric(7,2)
as
declare @int_fac int
print @@TRANCOUNT
begin transaction
print @@TRANCOUNT
if(select COUNT(*) from faculty where faculty.Name like @Faculty) = 0
	begin
		Print N'Такого факультета нет!'
		rollback transaction
		print @@TRANCOUNT
		return -1
	end
else
	begin
		select @int_fac=FacPK from faculty where faculty.Name like @Faculty
	end
if (select COUNT(*) from department where department.Name like @Name and  FacFK = @int_fac) > 0
	begin 
		Print N'Такая кафедра на факультете уже есть!'
		rollback transaction
		print @@TRANCOUNT
		return -1
	end
else
	begin try
		insert into department (FacFK, Name, Head, Building, Fund)
		values (@int_fac, @Name, @Head, @Building, @Fund)
		commit transaction
		print @@TRANCOUNT
		return 0
	end try
	begin catch
		 print N'Фонд финансирования кафедры должен быть положительным!'
		 rollback transaction
		 print @@TRANCOUNT
		 return -1
	end catch
go

execute  AddDepartment N'информатика', N'базы данных', N'Соколов', '6', 26000

begin transaction
execute  AddDepartment N'информатика', N'программирование', N'Федоров', '6', 12000
rollback transaction
print @@TRANCOUNT

execute  AddDepartment N'информатика', N'программирование', N'Федоров', '6', 12000
execute  AddDepartment N'информатика', N'интернет', N'Стрельцов', '3', 10000
execute  AddDepartment N'кибернетика', N'теория языков', N'Глущенко', '3', 10000
execute  AddDepartment N'кибернетика', N'лингвистика', N'Коробов', '3', 14100
execute  AddDepartment N'кибернетика', N'базы данных', N'Тараненко', '5', 27000

--begin transaction
execute  AddDepartment N'информатика', N'базы данных', N'Тараненко', '5', 27000
execute  AddDepartment N'история', N'базы данных', N'Тараненко', '5', 27000
execute  AddDepartment N'кибернетика', N'компьютерные сети', N'Иванов', '5', -27000

----------------------------------------------------
------- Блокировки и параллельная организация работы

CREATE DATABASE [Database_Books]
GO
USE [Database_Books]
GO
CREATE TABLE [dbo].[books](
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Name] [nvarchar](100) NULL,
	[Pages] [int] NULL,
	[YearPress] [int] NULL,
	[Themes] [nvarchar](50) NULL,
	[Author] [nvarchar](50) NULL,
	[Press] [nvarchar](50) NULL,
	[Comment] [nvarchar](50) NULL,
	[Quantity] [int] NULL
) ON [PRIMARY]
GO
INSERT [dbo].[books] ([Name], [Pages], [YearPress], [Themes], [Author], [Press], [Comment], [Quantity]) VALUES 
(N'SQL', 816, 2001, N'Базы данных', N'Грофф', N'BHV', N'2-е издание', 2)
,(N'3D Studio Max 3', 640, 2000, N'Графические пакеты', N'Маров', N'Питер', N'Учебный курс', 3)
,(N'100 компонентов общего назначения библиотеки Delphi 5', 272, 1999, N'Программирование', N'Архангельский', N'Бином', N'Компоненты', 1)
,(N'Курс математического анализа', 328, 1990, N'Высшая математика', N'Никольский', N'Наука', N'1-й том', 1)
,(N'Библиотека C++ Builder 5: 70 компонентов ввода/вывода информации', 288, 2000, N'Программирование', N'Архангельский', N'Бином', N'Компоненты', 1)
,(N'Интегрированная среда разработки', 272, 2000, N'Программирование', N'Архангельский', N'Бином', N'Среда разработки', 2)
,(N'Visual Basic 6.0 for Application', 488, 2000, N'Программирование', N'Король', N'DiaSoft', N'Справочник с примерами', 3)
,(N'Visual Basic 6', 576, 2000, N'Программирование', N'Петрусос', N'BHV', N'Руководство разработчика 1-й том', 1)
,(N'Mathcad 2000', 416, 2000, N'Математические пакеты', N'Херхагер', N'BHV', N'Полное руководство', 1)
,(N'Novell GroupWise 5.5 система электронной почты и коллективной работы', 480, 2000, N'Сети', N'Гарбар', N'BHV', N'Сетевые пакеты', 2)
,(N'Реестр Windows 2000', 352, 2000, N'Операционные системы', N'Кокорева', N'BHV', N'Руководство для профессионалов', 4)
,(N'Самоучитель Visual FoxPro 6.0', 512, 1999, N'Базы данных', N'Омельченко', N'BHV', N'Самоучитель', 1)
,(N'Самоучитель FrontPage 2000', 512, 1999, N'Web-дизайн', N'Омельченко', N'BHV', N'Самоучитель', 1)
,(N'Самоучитель Perl', 432, 2000, N'Программирование', N'Матросов', N'BHV', N'Самоучитель', 2)
,( N'HTML 3.2', 1040, 2000, N'Web-дизайн', N'Браун', N'BHV', N'Руководство', 5)

-- 1. Чтение незафиксированных данных

--первая транзакция
use Database_Books
go
begin transaction
update books set YearPress  = 2016 where YearPress = 1999
waitfor delay '0:0:10'
rollback transaction

--вторая транзакция
use Database_Books
go
begin transaction
--set transaction isolation level read uncommitted --Нарушение
set transaction isolation level read committed --Ok
select * from books
commit transaction

-- 2. Неповторяемое чтение

--первая транзакция
use Database_Books
go
begin transaction
--set transaction isolation level read committed --Нарушение
set transaction isolation level repeatable read --Ok
select * from books
waitfor delay '0:0:10'
select * from books
commit transaction

--вторая транзакция
use Database_Books
go
update books set YearPress  = 2016 where YearPress = 1999

-- 3. Фантомы

--первая транзакция
use Database_Books
go
begin transaction
--set transaction isolation level repeatable read --Нарушение
set transaction isolation level serializable --Ok
select * from books where YearPress = 1999
waitfor delay '0:0:10'
select * from books where YearPress = 1999
commit transaction

--вторая транзакция
use Database_Books
go
insert into books (Name, Pages, YearPress, Themes, Author, Press, Comment, Quantity )
values ('SQL', 1000, 1999, 'Базы данных', 'Генник', 'Питер', 'Карманный справочник', 3)


--первая транзакция
use Database_Books
go
begin transaction
--set transaction isolation level repeatable read --Нарушение
set transaction isolation level serializable --Ok
update books set YearPress  = 2016 where Press = 'Наука'
waitfor delay '0:0:10'
alter table books add constraint constr_year check ( YearPress>= 1999)
commit transaction

--вторая транзакция
use Database_Books
go
insert into books (Name, Pages, YearPress, Themes, Author, Press, Comment, Quantity )
values ('SQL', 1000, 1992, 'Базы данных', 'Генник', 'Питер', 'Карманный справочник', 3)

---------------------------------------------------
-- работа со схемой SQL

-- Создание схемы
CREATE SCHEMA CustomSchema;

-- при любых действиях нужно будет указывать название схемы, например:
CREATE TABLE CustomSchema.Employees (
    EmployeeID INT PRIMARY KEY,
    LastName NVARCHAR(50),
    FirstName NVARCHAR(50),
    BirthDate DATE,
    HireDate DATE
);

-- В SQL Server нельзя напрямую изменить схему объекта (таблицы, представления, хранимой процедуры и т.д.). 
-- Вместо этого, вы можете переместить объект в другую схему с помощью команды ALTER SCHEMA.

--ALTER SCHEMA NewSchema TRANSFER OldSchema.Employees;
CREATE SCHEMA CustomSchemaMew;

ALTER SCHEMA CustomSchemaMew TRANSFER CustomSchema.Employees;

-- Чтобы удалить схему в SQL Server, сначала необходимо убедиться, что она пуста, то есть все объекты внутри схемы должны быть удалены или перемещены в другую схему.

DECLARE @SchemaName NVARCHAR(128) = 'CustomSchemaMew';
DECLARE @SQL NVARCHAR(MAX) = '';

-- Удаление таблиц
SELECT @SQL = @SQL + 'DROP TABLE ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(t.name) + ';' + CHAR(13)
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = @SchemaName;

-- Удаление процедур
SELECT @SQL = @SQL + 'DROP PROCEDURE ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(p.name) + ';' + CHAR(13)
FROM sys.procedures p
JOIN sys.schemas s ON p.schema_id = s.schema_id
WHERE s.name = @SchemaName;

-- Удаление представлений
SELECT @SQL = @SQL + 'DROP VIEW ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(v.name) + ';' + CHAR(13)
FROM sys.views v
JOIN sys.schemas s ON v.schema_id = s.schema_id
WHERE s.name = @SchemaName;

-- Выполнение динамического SQL для удаления объектов
EXEC sp_executesql @SQL;

-- Удаление самой схемы
SET @SQL = 'DROP SCHEMA ' + QUOTENAME(@SchemaName);
EXEC sp_executesql @SQL;

---------------------------------------------
-- Merge: upsert операция (update + insert)

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    LastName NVARCHAR(50),
    FirstName NVARCHAR(50),
    BirthDate DATE,
    HireDate DATE
);
GO
INSERT INTO Employees (EmployeeID, LastName, FirstName, BirthDate, HireDate) VALUES
(1, 'Vasya', 'Pupkin', '1990-05-15', '2010-08-20')

select * from Employees

-- Предположим, у нас есть временная таблица с новыми данными, которые нужно вставить или обновить
CREATE TABLE #NewEmployees (
    EmployeeID INT,
    LastName NVARCHAR(50),
    FirstName NVARCHAR(50),
    BirthDate DATE,
    HireDate DATE
);

INSERT INTO #NewEmployees (EmployeeID, LastName, FirstName, BirthDate, HireDate) VALUES
(1, 'Smith', 'John', '1990-05-15', '2010-08-20'),  -- Должен обновиться в дальнейшем
(3, 'Doe', 'Jane', '1985-10-25', '2008-04-12');    -- Должен вставиться в дальнейшем

-- Пример MERGE для upsert

MERGE INTO Employees AS Target
USING #NewEmployees AS Source
ON Target.EmployeeID = Source.EmployeeID

-- Обновление, если запись существует
WHEN MATCHED THEN
    UPDATE SET 
        Target.LastName = Source.LastName,
        Target.FirstName = Source.FirstName,
        Target.BirthDate = Source.BirthDate,
        Target.HireDate = Source.HireDate

-- Вставка, если запись не существует
WHEN NOT MATCHED BY TARGET THEN
    INSERT (EmployeeID, LastName, FirstName, BirthDate, HireDate)
    VALUES (Source.EmployeeID, Source.LastName, Source.FirstName, Source.BirthDate, Source.HireDate);

-- Если нужно удалить записи, которых нет в Source, можно использовать это условие
-- WHEN NOT MATCHED BY SOURCE THEN
--     DELETE;

-- Завершение оператора MERGE
;

select * from Employees

-- 1. MERGE INTO Employees AS Target: указывает целевую таблицу Employees, в которую будут вноситься изменения.
-- 2. USING #NewEmployees AS Source: указывает источник данных, который содержит новые данные.
-- 3. ON Target.EmployeeID = Source.EmployeeID: определяет условие сопоставления между целевой и исходной таблицами.
-- 4. WHEN MATCHED THEN UPDATE: обновляет целевую таблицу, если запись существует в обеих таблицах.
-- 5. WHEN NOT MATCHED BY TARGET THEN INSERT: вставляет новую запись в целевую таблицу, если запись отсутствует в целевой таблице, но присутствует в исходной.
