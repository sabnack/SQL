--Написати такі тригери: 
--Щоб під час узяття певної книги, її кількість зменшувалася на 1. 

create trigger trg_TCards_books_subtract_quantity
on T_Cards
after insert, update
as
if update(DateOut) 
	begin
		update Books
		set Quantity -= 1
		where Id = (select Id_Book from inserted);
	end
go

create trigger trg_SCardbooks_subtract_quantity
on S_Cards
after insert, update
as
if update(DateOut)
	begin
		update Books
		set Quantity -= 1
		where Id = (select Id_Book from inserted);
	end
go

--Щоб при поверненні певної книги, її кількість збільшувалася на 1. 

create trigger trg_TCards_books_add_quantity
on T_Cards
after update
as
if update(DateIn)
	begin
		update Books
		set Quantity += 1
		where Id = (select Id_Book from inserted);
	end
go

create trigger trg_SCardbooks_add_quantity
on S_Cards
after update
as
if update(DateIn)
	begin
		update Books
		set Quantity += 1
		where Id = (select Id_Book from inserted);
	end
go

--Щоб не можна було видати книжку, якої вже немає в бібліотеці (за кількістю). 

create trigger trg_CheckBookAvailability
on S_Cards
instead of insert
as
begin
	begin tran;
	declare @Id_Book int;
	declare @AvailableQuantity int;

	select @Id_Book = Id_Book from inserted;

	select @AvailableQuantity = Quantity from Books
	where Id = @Id_Book;


	IF @AvailableQuantity >= 1
	begin
		insert into S_Cards select Id_Student, Id_Book, DateOut, DateIn,Id_Lib from inserted
	end
	else
	begin
		raiserror('Книги нет в наличии!', 16, 1);
	end
end

--Щоб не можна було видати більше трьох книг одному студенту.

create trigger trg_check_books_count_student
on S_Cards
instead of insert
as
--begin tran;
	declare @BooksCount int;
	declare @Id_Student int;
	
	select @Id_Student = Id_Student from inserted;

	select @BooksCount = count(*)
    from S_Cards
    where Id_Student = @Id_Student;

	if(@BooksCount <= 3)
		begin
			insert into S_Cards select Id_Student, Id_Book, DateOut, DateIn,Id_Lib from inserted
		end;
	else
		begin
			raiserror('Перевышен лимит книг!', 16, 1);
		end

go

--Щоб при видаленні книги, дані про неї копіювалися в таблицю Видалені (створити цю таблицю). 
create table DeletedBooks(
	[Id] [int] IDENTITY(1,1) NOT NULL primary key,
	[OriginId] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Pages] [int] NOT NULL,
	[YearPress] [int] NOT NULL,
	[Id_Themes] [int] NULL,
	[Id_Category] [int] NULL,
	[Id_Author] [int] NOT NULL,
	[Id_Press] [int] NOT NULL,
	[Comment] [nvarchar](50) NULL,
	[Quantity] [int] NOT NULL,
)

create trigger trg_copy_deleted_book
on Books
after delete
as
insert into DeletedBooks 
select Id, [Name], Pages, YearPress, Id_Themes, Id_Category, Id_Author, Id_Press, Comment, Quantity
from deleted
go

--Якщо книжка додається в базу, вона має бути видалена з таблиці Видалені.

create trigger trg_add_book
on Books
after insert
as
	declare @BookName nvarchar(100);
	declare @DeletedId int;
	select @BookName = [Name] from inserted;
	
	if exists(select Id from  DeletedBooks where [Name]=@BookName)
	begin 
		select @DeletedId = Id from  DeletedBooks where [Name]=@BookName	
		delete from DeletedBooks where Id= @DeletedId
	end

go

