--Використовуючи Triggers / Views або Updatable Views / Stored procedures / Functions реалізуйте наступну функціональність: 
use Barbershop
go
--■ Повернути ПІБ всіх барберів салону. 
create view BarbersFio as
select FullName
from Barbers
go
select * from BarbersFio
go

--■ Повернути інформацію про всіх синьйор-барберів. 
create view SeniorBarber as
select FullName, Gender, PhoneNumber, Email, DateOfBirth, HireDate
from Barbers
where Position like 'Senior%'
go
select * from SeniorBarber
go

--■ Повернути інформацію про всіх барберів, які можуть надати послугу традиційного гоління бороди. 
create view BarberShave as
select b.FullName, b.Gender, b.PhoneNumber, b.Email, b.DateOfBirth, b.HireDate, s.ServiceName
from Barbers b
join [Services] s
on s.BarberID = b.BarberID
where ServiceName = 'Shave'

go
select * from BarberShave
go

--■ Повернути інформацію про всіх барберів, які можуть надати конкретну послугу. Інформація про потрібну послугу надається як параметр.
create procedure  GetBarbersByService
	@service nvarchar(100)
AS
	select b.FullName, b.Gender, b.PhoneNumber, b.Email, b.DateOfBirth, b.HireDate, s.ServiceName
		from Barbers b
		join [Services] s
		on s.BarberID = b.BarberID
		where ServiceName = @service

go
exec GetBarbersByService 'Beard Trim'
go

--■ Повернути інформацію про всіх барберів, які працюють понад зазначену кількість років. Кількість років передається як параметр. 
create procedure  GetBarbersByYear
	@years int
AS
	select b.FullName, b.Gender, b.PhoneNumber, b.Email, b.DateOfBirth, b.HireDate
		from Barbers b
		where datediff(year, HireDate, GetDate()) > @years

go
exec GetBarbersByYear 2
go

--■ Повернути кількість синьйор-барберів та кількість джуніор-барберів. 
create view GetBarberJuniorAndSenior as
select Position, count(*) as Count
from Barbers b
where Position != 'Chief Barber'
group by Position

go
select * from GetBarberJuniorAndSenior
go

--■ Повернути інформацію про постійних клієнтів. Критерій постійного клієнта: був у салоні задану кількість разів. Кількість передається як параметр. 

create procedure  GetClientsByVisitCount
	@visitCount int
AS
		select * 
		from Clients 
		where ClientID in (
		select v.ClientID
		from Visits v
		group by v.ClientID
		having count(*) > @visitCount)

go
exec GetClientsByVisitCount 7
go

--■ Заборонити можливість видалення інформації про чиф-барбер, якщо не додано другий чиф-барбер. 

--■ Заборонити додавати барберів молодше 21 року
alter table Barbers
add constraint CK_Barber_Age check (DATEDIFF(YEAR, DateOfBirth, GETDATE()) >= 21);
go

insert into Barbers (FullName, Gender, PhoneNumber, Email, DateOfBirth, HireDate, Position)
values
('John Doe', 'Male', '1234567890', 'john@example.com', '2010-01-15', '2020-05-01', 'Chief Barber');
go
--create database Barbershop;
--go

--use Barbershop;

--go

--create table Barbers (
--	BarberID int identity(1,1) primary key,
--	FullName nvarchar(100) not null,
--	Gender nvarchar(10) not null,
--	PhoneNumber nvarchar(15) not null,
--	Email nvarchar(100) not null,
--	DateOfBirth date not null,
--	HireDate date not null,
--	Position nvarchar(50) not null check (Position IN ('Chief Barber', 'Senior Barber', 'Junior Barber'))
--);

--create table [Services] (
--	ServiceID int identity(1,1) primary key,
--	BarberID int NOT NULL,
--	ServiceName nvarchar(100) not null,
--	Price decimal(10, 2) not null,
--	Duration time not null,
--	foreign key (BarberID) REFERENCES Barbers(BarberID)
--);

--create table BarberFeedbacks (
--	FeedbackID int identity(1,1) primary key,
--	BarberID int not null,
--	ClientID int not null,
--	Feedback nvarchar(1000),
--	Rating nvarchar(20) not null check (Rating IN ('Very Bad', 'Bad', 'Normal', 'Good', 'Excellent')),
--	foreign key (BarberID) references Barbers(BarberID)
--);

--create table BarberSchedules (
--	ScheduleID int identity(1,1) primary key,
--	BarberID int not null,
--	AvailableDate date not null,
--	AvailableTime time not null,
--	ClientID int,
--	foreign key (BarberID) references Barbers(BarberID)
--);

--create table Clients (
--	ClientID int identity(1,1) primary key,
--	FullName nvarchar(100) not null,
--	PhoneNumber nvarchar(15) not null,
--	Email nvarchar(100) not null,
--);

--create table ClientFeedbacks (
--	FeedbackID int identity(1,1) primary key,
--	ClientID int not null,
--	BarberID int not null,
--	Feedback nvarchar(1000),
--	Rating nvarchar(20) not null check (Rating IN ('Very Bad', 'Bad', 'Normal', 'Good', 'Excellent')),
--	foreign key (ClientID) references Clients(ClientID),
--	foreign key (BarberID) references Barbers(BarberID)
--);

--create table Visits (
--	VisitID int identity(1,1) primary key,
--	ClientID int not null,
--	BarberID int not null,
--	ServiceID int not null,
--	VisitDate date not null,
--	TotalCost decimal(10, 2) not null,
--	Rating nvarchar(20) check (Rating in ('Very Bad', 'Bad', 'Normal', 'Good', 'Excellent')),
--	Feedback nvarchar(1000),
--	foreign key (ClientID) references Clients(ClientID),
--	foreign key (BarberID) references Barbers(BarberID),
--	foreign key (ServiceID) references [Services](ServiceID)
--);

--go

--insert into Barbers (FullName, Gender, PhoneNumber, Email, DateOfBirth, HireDate, Position)
--values
--('John Doe', 'Male', '1234567890', 'john@example.com', '1985-01-15', '2020-05-01', 'Chief Barber'),
--('Jane Smith', 'Female', '0987654321', 'jane@example.com', '1990-04-25', '2021-07-01', 'Senior Barber'),
--('Mike Johnson', 'Male', '1112223333', 'mike@example.com', '1995-08-10', '2022-01-01', 'Junior Barber');

--insert into [Services] (BarberID, ServiceName, Price, Duration)
--values
--(1, 'Haircut', 25.00, '00:30:00'),
--(1, 'Shave', 15.00, '00:20:00'),
--(2, 'Haircut', 20.00, '00:30:00'),
--(2, 'Beard Trim', 10.00, '00:15:00'),
--(3, 'Haircut', 15.00, '00:30:00');

--insert into Clients (FullName, PhoneNumber, Email)
--values
--('Alice Brown', '2223334444', 'alice@example.com'),
--('Bob White', '5556667777', 'bob@example.com');

--insert into BarberSchedules (BarberID, AvailableDate, AvailableTime)
--values
--(1, '2023-07-20', '10:00:00'),
--(1, '2023-07-20', '11:00:00'),
--(2, '2023-07-21', '14:00:00'),
--(3, '2023-07-22', '16:00:00');

--insert into BarberFeedbacks (BarberID, ClientID, Feedback, Rating)
--values
--(1, 1, 'Great haircut!', 'Excellent'),
--(2, 2, 'Good service.', 'Good');

--insert into Visits (ClientID, BarberID, ServiceID, VisitDate, TotalCost, Rating, Feedback)
--values
--(1, 1, 1, '2023-07-10', 25.00, 'Excellent', 'Loved the haircut!'),
--(2, 2, 3, '2023-07-11', 20.00, 'Good', 'Satisfied with the service.'),
--(1, 1, 1, '2023-07-10', 25.00, 'Excellent', 'Loved the haircut!'),
--(2, 2, 3, '2023-07-11', 20.00, 'Good', 'Satisfied with the service.'),
--(1, 1, 1, '2023-07-10', 25.00, 'Excellent', 'Loved the haircut!'),
--(2, 2, 3, '2023-07-11', 20.00, 'Good', 'Satisfied with the service.'),
--(1, 1, 1, '2020-07-10', 25.00, 'Excellent', 'Loved the haircut!'),
--(1, 2, 3, '2023-07-11', 20.00, 'Good', 'Satisfied with the service.'),
--(1, 1, 1, '2023-07-10', 25.00, 'Excellent', 'Loved the haircut!'),
--(2, 2, 3, '2024-07-11', 20.00, 'Good', 'Satisfied with the service.'),
--(1, 1, 1, '2022-07-10', 25.00, 'Excellent', 'Loved the haircut!'),
--(1, 2, 3, '2023-07-11', 20.00, 'Good', 'Satisfied with the service.'),
--(1, 1, 1, '2021-07-10', 25.00, 'Excellent', 'Loved the haircut!'),
--(2, 2, 3, '2023-07-11', 20.00, 'Good', 'Satisfied with the service.');


