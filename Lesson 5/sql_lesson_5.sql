-----------------------------------------
--З'єднання таблиць

--Неявне з'єднання таблиць

--Для даних з різних таблиць ми можемо використовувати стандартну команду SELECT. 
--Допустимо, у нас є такі таблиці, які пов'язані між собою зв'язками:
 
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

go

INSERT INTO Products 
VALUES ('iPhone 6', 'Apple', 2, 36000),
('iPhone 6S', 'Apple', 2, 41000),
('iPhone 7', 'Apple', 5, 52000),
('Galaxy S8', 'Samsung', 2, 46000),
('Galaxy S8 Plus', 'Samsung', 1, 56000),
('Mi 5X', 'Xiaomi', 2, 26000),
('OnePlus 5', 'OnePlus', 6, 38000)
 
INSERT INTO Customers VALUES ('Tom'), ('Bob'),('Sam')
 
INSERT INTO Orders 
VALUES
( 
    (SELECT Id FROM Products WHERE ProductName='Galaxy S8'), 
    (SELECT Id FROM Customers WHERE FirstName='Tom'),
    '2017-07-11',  
    2, 
    (SELECT Price FROM Products WHERE ProductName='Galaxy S8')
),
( 
    (SELECT Id FROM Products WHERE ProductName='iPhone 6S'), 
    (SELECT Id FROM Customers WHERE FirstName='Tom'),
    '2017-07-13',  
    1, 
    (SELECT Price FROM Products WHERE ProductName='iPhone 6S')
),
( 
    (SELECT Id FROM Products WHERE ProductName='iPhone 6S'), 
    (SELECT Id FROM Customers WHERE FirstName='Bob'),
    '2017-07-11',  
    1, 
    (SELECT Price FROM Products WHERE ProductName='iPhone 6S')
)

go

SELECT * FROM Orders, Customers
--При такій вибірці для кожного рядка з таблиці Orders поєднуватиметься з кожним рядком з таблиці Customers. Тобто вийде перехресне сполучення. 
--Наприклад, в Orders три рядки, а в Customers те ж три рядки, отже ми отримаємо 3*3 = 9 рядків

--
SELECT * FROM Orders, Customers
WHERE Orders.CustomerId = Customers.Id

--
SELECT Customers.FirstName, Products.ProductName, Orders.CreatedAt 
FROM Orders, Customers, Products
WHERE Orders.CustomerId = Customers.Id AND Orders.ProductId=Products.Id

--
SELECT C.FirstName, P.ProductName, O.CreatedAt 
FROM Orders AS O, Customers AS C, Products AS P
WHERE O.CustomerId = C.Id AND O.ProductId=P.Id

-- or
SELECT C.FirstName, P.ProductName, O.*
FROM Orders AS O, Customers AS C, Products AS P
WHERE O.CustomerId = C.Id AND O.ProductId=P.Id

-----
-- INNER JOIN

--SELECT столбцы
--FROM таблица1
--    [INNER] JOIN таблица2
--    ON условие1
--    [[INNER] JOIN таблица3
--    ON условие2]

--Після оператора JOIN йде назва другої таблиці, з якої треба додати дані у вибірку. 
--Перед JOIN може використовуватися необов'язкове ключове слово INNER . Його наявність чи відсутність ні на що не впливає. 
--Після ключового слова ON вказується умова з'єднання. Ця умова встановлює, як дві таблиці порівнюватимуть. 
--У більшості випадків для з'єднання застосовується первинний ключ головної таблиці та зовнішній ключ залежної таблиці.

SELECT Orders.CreatedAt, Orders.ProductCount, Products.ProductName 
FROM Orders
JOIN Products ON Products.Id = Orders.ProductId

--
SELECT O.CreatedAt, O.ProductCount, P.ProductName 
FROM Orders AS O
JOIN Products AS P
ON P.Id = O.ProductId

--
SELECT Orders.CreatedAt, Customers.FirstName, Products.ProductName 
FROM Orders
JOIN Products ON Products.Id = Orders.ProductId
JOIN Customers ON Customers.Id=Orders.CustomerId

--
SELECT Orders.CreatedAt, Customers.FirstName, Products.ProductName 
FROM Orders
JOIN Products ON Products.Id = Orders.ProductId
JOIN Customers ON Customers.Id=Orders.CustomerId
WHERE Products.Price < 45000
ORDER BY Customers.FirstName

--
SELECT Orders.CreatedAt, Customers.FirstName, Products.ProductName 
FROM Orders
JOIN Products ON Products.Id = Orders.ProductId AND Products.Manufacturer='Apple'
JOIN Customers ON Customers.Id=Orders.CustomerId
ORDER BY Customers.FirstName

--При використанні оператора JOIN слід враховувати, що процес з'єднання таблиць може бути ресурсомістким, тому слід з'єднувати лише таблиці, 
--дані з яких дійсно необхідні. 
--Чим більше таблиць з'єднується, тим більше знижується продуктивність.

-------------------
-- OUTER JOIN

--SELECT столбцы
--FROM таблица1
--    {LEFT|RIGHT|FULL} [OUTER] JOIN таблица2 ON условие1
--    [{LEFT|RIGHT|FULL} [OUTER] JOIN таблица3 ON условие2]...

--Перед оператором JOIN вказується одне з ключових слів LEFT , RIGHT або FULL , які визначають тип з'єднання:

--LEFT : вибірка міститиме всі рядки з першої або лівої таблиці

--RIGHT : вибірка міститиме всі рядки з другої або правої таблиці

--FULL : вибірка міститиме всі рядки з обох таблиць

--Також перед оператором JOIN може вказуватись ключове слово OUTER , але його застосування необов'язкове. 
--Далі після JOIN вказується таблиця, що приєднується, а потім йде умова з'єднання.

SELECT FirstName, CreatedAt, ProductCount, Price, ProductId 
FROM Orders LEFT JOIN Customers 
ON Orders.CustomerId = Customers.Id

-- INNER JOIN
SELECT FirstName, CreatedAt, ProductCount, Price 
FROM Customers JOIN Orders 
ON Orders.CustomerId = Customers.Id
 
--LEFT JOIN
SELECT FirstName, CreatedAt, ProductCount, Price 
FROM Customers LEFT JOIN Orders 
ON Orders.CustomerId = Customers.Id

--
SELECT FirstName, CreatedAt, ProductCount, Price, ProductId 
FROM Orders RIGHT JOIN Customers 
ON Orders.CustomerId = Customers.Id

--
SELECT Customers.FirstName, Orders.CreatedAt, 
       Products.ProductName, Products.Manufacturer
FROM Orders 
LEFT JOIN Customers ON Orders.CustomerId = Customers.Id
LEFT JOIN Products ON Orders.ProductId = Products.Id

--
SELECT Customers.FirstName, Orders.CreatedAt, 
       Products.ProductName, Products.Manufacturer
FROM Orders 
LEFT JOIN Customers ON Orders.CustomerId = Customers.Id
LEFT JOIN Products ON Orders.ProductId = Products.Id
WHERE Products.Price < 45000
ORDER BY Orders.CreatedAt

--
SELECT FirstName FROM Customers
LEFT JOIN Orders ON Customers.Id = Orders.CustomerId
WHERE Orders.CustomerId IS NULL

--
SELECT Customers.FirstName, Orders.CreatedAt, 
       Products.ProductName, Products.Manufacturer
FROM Orders 
JOIN Products ON Orders.ProductId = Products.Id AND Products.Price < 45000
LEFT JOIN Customers ON Orders.CustomerId = Customers.Id
ORDER BY Orders.CreatedAt

-- Cross Join
SELECT * FROM Orders CROSS JOIN Customers
-- При неявному перехресному з'єднанні можна опустити оператор CROSS JOIN і просто перерахувати всі таблиці:
SELECT * FROM Orders, Customers
-------------------------------
-- Угруповання у з'єднаннях
-- У виразах INNER/OUTER JOIN також можна використовувати групування. 
-- Наприклад, виведемо для кожного користувача кількість замовлень, які він зробив:

SELECT FirstName, COUNT(Orders.Id)
FROM Customers JOIN Orders 
ON Orders.CustomerId = Customers.Id
GROUP BY Customers.Id, Customers.FirstName;

--Критерієм угруповання виступають Id та ім'я покупця. Вираз SELECT вибирає ім'я покупця та кількість замовлень, 
--використовуючи стовпець Id із таблиці Orders.

--Так як це INNER JOIN, то в групах будуть лише покупці, які мають замовлення.

--Якщо необхідно вивести навіть тих покупців, які не мають замовлень, то застосовується OUTER JOIN

SELECT FirstName, COUNT(Orders.Id)
FROM Customers LEFT JOIN Orders 
ON Orders.CustomerId = Customers.Id
GROUP BY Customers.Id, Customers.FirstName;

-- Або виведемо товари із загальною сумою зроблених замовлень:
SELECT Products.ProductName, Products.Manufacturer, 
        SUM(Orders.ProductCount * Orders.Price) AS Units
FROM Products LEFT JOIN Orders
ON Orders.ProductId = Products.Id
GROUP BY Products.Id, Products.ProductName, Products.Manufacturer

------------
-- UNION 

--Оператор UNION подібно до inner join або outer join дозволяє з'єднати дві таблиці. 
--Але, на відміну від inner/outer join, об'єднання з'єднують не стовпці різних таблиць, а два однотипних набори в один. 

--SELECT_выражение1
--UNION [ALL] SELECT_выражение2
--[UNION [ALL] SELECT_выражениеN]

CREATE TABLE Customers
(
    Id INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(20) NOT NULL,
    LastName NVARCHAR(20) NOT NULL,
    AccountSum MONEY
);
CREATE TABLE Employees
(
    Id INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(20) NOT NULL,
    LastName NVARCHAR(20) NOT NULL,
);
 
INSERT INTO Customers VALUES
('Tom', 'Smith', 2000),
('Sam', 'Brown', 3000),
('Mark', 'Adams', 2500),
('Paul', 'Ins', 4200),
('John', 'Smith', 2800),
('Tim', 'Cook', 2800)
 
INSERT INTO Employees VALUES
('Homer', 'Simpson'),
('Tom', 'Smith'),
('Mark', 'Adams'),
('Nick', 'Svensson')

---
SELECT FirstName, LastName 
FROM Customers
UNION SELECT FirstName, LastName FROM Employees

--
SELECT FirstName + ' ' +LastName AS FullName
FROM Customers
UNION SELECT FirstName + ' ' + LastName AS EmployeeName 
FROM Employees
ORDER BY FullName DESC

--
SELECT FirstName, LastName, AccountSum
FROM Customers
UNION SELECT FirstName, LastName 
FROM Employees

--
SELECT FirstName, LastName
FROM Customers
UNION SELECT Id, LastName 
FROM Employees

--
SELECT FirstName, LastName
FROM Customers
UNION ALL SELECT FirstName, LastName 
FROM Employees

--
SELECT FirstName, LastName, AccountSum + AccountSum * 0.1 AS TotalSum 
FROM Customers WHERE AccountSum < 3000
UNION SELECT FirstName, LastName, AccountSum + AccountSum * 0.3 AS TotalSum 
FROM Customers WHERE AccountSum >= 3000

-----------------------
-- EXCEPT

-- Оператор EXCEPT дозволяє знайти різницю двох вибірок, тобто ті рядки, які є в першій вибірці, але яких немає в другій. 

--SELECT_выражение1
--EXCEPT SELECT_выражение2

SELECT FirstName, LastName
FROM Customers
EXCEPT SELECT FirstName, LastName 
FROM Employees

--
SELECT FirstName, LastName
FROM Employees
EXCEPT SELECT FirstName, LastName 
FROM Customers

--------------
-- INTERSECT

-- Оператор INTERSECT дозволяє знайти спільні рядки для двох вибірок, тобто оператор виконує операцію перетину множин.

--SELECT_выражение1
--INTERSECT SELECT_выражение2

SELECT FirstName, LastName
FROM Employees
INTERSECT SELECT FirstName, LastName 
FROM Customers

------------------------------------------------------------
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
