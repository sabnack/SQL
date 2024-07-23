create database Barbershop;
go

use Barbershop;

go

create table Barbers (
	BarberID int identity(1,1) primary key,
	FirstName nvarchar(100) not null,
	LastName nvarchar(100) not null,
	Gender nvarchar(10) not null,
	PhoneNumber nvarchar(15) not null,
	Email nvarchar(100) not null,
	DateOfBirth date not null,
	HireDate date not null,
	Position nvarchar(50) not null check (Position IN ('Chief Barber', 'Senior Barber', 'Junior Barber'))
);

create table [Services] (
	ServiceID int identity(1,1) primary key,
	BarberID int NOT NULL,
	ServiceName nvarchar(100) not null,
	Price decimal(10, 2) not null,
	Duration time not null,
	foreign key (BarberID) REFERENCES Barbers(BarberID)
);

create table BarberFeedbacks (
	FeedbackID int identity(1,1) primary key,
	BarberID int not null,
	ClientID int not null,
	Feedback nvarchar(1000),
	Rating nvarchar(20) not null check (Rating IN ('Very Bad', 'Bad', 'Normal', 'Good', 'Excellent')),
	foreign key (BarberID) references Barbers(BarberID)
);

create table BarberSchedules (
	ScheduleID int identity(1,1) primary key,
	BarberID int not null,
	AvailableDate date not null,
	AvailableTime time not null,
	ClientID int,
	foreign key (BarberID) references Barbers(BarberID)
);

create table Clients (
	ClientID int identity(1,1) primary key,
	FirstName nvarchar(100) not null,
	LastName nvarchar(100) not null,
	PhoneNumber nvarchar(15) not null,
	Email nvarchar(100) not null,
);

create table ClientFeedbacks (
	FeedbackID int identity(1,1) primary key,
	ClientID int not null,
	BarberID int not null,
	Feedback nvarchar(1000),
	Rating nvarchar(20) not null check (Rating IN ('Very Bad', 'Bad', 'Normal', 'Good', 'Excellent')),
	foreign key (ClientID) references Clients(ClientID),
	foreign key (BarberID) references Barbers(BarberID)
);

create table Visits (
	VisitID int identity(1,1) primary key,
	ClientID int not null,
	BarberID int not null,
	ServiceID int not null,
	VisitDate date not null,
	TotalCost decimal(10, 2) not null,
	Rating nvarchar(20) check (Rating in ('Very Bad', 'Bad', 'Normal', 'Good', 'Excellent')),
	Feedback nvarchar(1000),
	foreign key (ClientID) references Clients(ClientID),
	foreign key (BarberID) references Barbers(BarberID),
	foreign key (ServiceID) references [Services](ServiceID)
);
