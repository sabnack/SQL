--Створіть наступні функції користувача (Functions): 

--■ Функція користувача повертає вітання в стилі «Hello, ІМ'Я!» Де ІМ'Я передається як параметр. Наприклад, якщо передали Nick, то буде Hello, Nick! 
create function Hello (@name varchar(50))
	returns varchar(70)
begin
	return concat('Hello ', @name, '!');
end

go 

select dbo.Hello('Nick')

go
--■ Функція користувача повертає інформацію про поточну кількість хвилин; 
create function GetMinutes ()
	returns tinyint
begin
	return datepart(minute, GETDATE());
end

go 

select dbo.GetMinutes()

go
--■ Функція користувача повертає інформацію про поточний рік; 
create function GetYear ()
	returns smallint
begin
	return datepart(YEAR, GETDATE());
end

go 

select dbo.GetYear()

go

--■ Функція користувача повертає інформацію про те: парний або непарний рік; 
create function IsEvenYear ()
	returns varchar(4)
begin
	declare @year smallint;
	set @year = datepart(YEAR, GETDATE());
	return iif(@year % 2 = 0, 'Even', 'Odd');
end

go 

select dbo.IsEvenYear()

go

--■ Функція користувача приймає число і повертає yes, якщо число просте і no, якщо число не просте; 
create function IsPrimeNumber (@number int)
	returns varchar(3)
begin
	declare @isPrime bit
	declare @counter int

	set @isPrime = 1
	set @counter = 2

	while (@counter < @number )
	begin
		if (( @number % @counter) = 0 )
		begin
			set @isPrime = 0
			break
		end


		set @counter = @counter + 1
	end
	return iif(@isPrime = 1, 'yes', 'no' )
	
end

go 

select dbo.IsPrimeNumber(108)

go

--■ Функція користувача приймає як параметри п'ять чисел. Повертає суму мінімального та максимального значення з переданих п'яти параметрів;

create function MinMaxSum (@number1 int, @number2 int, @number3 int, @number4 int, @number5 int)
	returns int
begin
	declare @numbers table(Id int);
	insert into @numbers values (@number1), (@number2), (@number3), (@number4), (@number5)
	
	declare @result int

	select @result = sum(Id) from
			(select min(id) as Id from @numbers
			union
			select max(id) from @numbers) as tb

	return @result
end

go 

select dbo.MinMaxSum(5,56,45,99,3)

go
--■ Функція користувача показує всі парні або непарні числа в переданому діапазоні. Функція приймає три параметри: початок діапазону, кінець діапазону, парне чи непарне показувати.

create function GetEvenNumbers (@start int, @end int)
	returns  @evenNumbers table(Even int)
as
begin
	while (@start <= @end )
	begin
		if(@start % 2 = 0)
		begin
			insert into @evenNumbers values (@start)
		end

		set @start += 1
	end

	return
end

go 

select * from dbo.GetEvenNumbers(5,50)

go

--Створіть наступні збережені процедури (Stored procedures): 

--■ Збережена процедура виводить «Hello, world!»; 
create procedure HelloWorld as
begin
	select 'Hello, world!'
end;
go
exec HelloWorld

--■ Збережена процедура повертає інформацію про поточний час; 
create procedure GetHour as
begin
	select datepart(HOUR, GETDATE());
end;
go
exec GetHour

--■ Збережена процедура повертає інформацію про поточну дату; 
create procedure GetCurrentDate as
begin
	select GETDATE();
end;
go
exec GetCurrentDate

--■ Збережена процедура приймає три числа і повертає їхню суму; 

create procedure  SumOfNumbers
    @number1 int, @number2 int, @number3 int
AS
	declare @numbers table(Id int);
	insert into @numbers values (@number1), (@number2), (@number3)
	select sum(Id) as SumNumbers from @numbers

go
exec SumOfNumbers 5, 6, 7

--■ Збережена процедура приймає три числа і повертає середньоарифметичне трьох чисел; 
create procedure  AvgOfNumbers
    @number1 int, @number2 int, @number3 int
AS
	declare @numbers table(Id int);
	insert into @numbers values (@number1), (@number2), (@number3)
	select avg(Id) as Average from @numbers

go
exec AvgOfNumbers 5, 6, 7

--■ Збережена процедура приймає три числа і повертає максимальне значення; 
create procedure  MaxOfNumbers
    @number1 int, @number2 int, @number3 int
AS
	declare @numbers table(Id int);
	insert into @numbers values (@number1), (@number2), (@number3)
	select max(Id) as MaxNumber from @numbers

go
exec MaxOfNumbers 5, 7, 6

--■ Збережена процедура приймає три числа і повертає мінімальне значення; 
create procedure  MinOfNumbers
    @number1 int, @number2 int, @number3 int
AS
	declare @numbers table(Id int);
	insert into @numbers values (@number1), (@number2), (@number3)
	select min(Id) as MinNumber from @numbers

go
exec MinOfNumbers 5, 7, 6


--■ Збережена процедура приймає число та символ. 
--В результаті роботи збереженої процедури відображається  лінія довжиною, що дорівнює числу. Лінія побудована із символу, вказаного у другому параметрі. 
--Наприклад, якщо було передано 5 та #, ми отримаємо лінію такого виду #####; 
create procedure DrawLine
	@length INT, @character CHAR(1)
as
begin
	declare @line nvarchar(MAX) = '';

	while @length > 0
	begin
		set @line = @line + @character;
		set @length = @length - 1;
	end

    print @line;
end;

go

exec DrawLine 20, '*'

--■ Збережена процедура приймає як параметр число і повертає його факторіал. 
--Формула розрахунку факторіалу: n! = 1 * 2 * ... n. Наприклад, 3! = 1 * 2 * 3 = 6; 

create procedure  Factorial
	@number int
AS
begin
	declare @factorial bigint;
	set @factorial = 1;

	while @number > 0
	begin
		set @factorial = @factorial * @number;
		set @number = @number - 1;
	end
	select @factorial as Factorial
end

go

exec Factorial 5

--■ Збережена процедура приймає два числові параметри. Перший параметр – це число. 
--Другий параметр – це ступінь. Процедура повертає число, зведене до ступеня. 
--Наприклад, якщо параметри дорівнюють 2 і 3, тоді повернеться 2 у третьому ступені, тобто 8.

create procedure Degree
	@number int,
	@degree int
AS
begin
	declare @result bigint;
	set @result = 1;

	while @degree > 0
	begin
		set @result = @result * @number;
		set @degree -= 1;
	end
	select @result as Degree;
end

go

exec Degree 3, 5