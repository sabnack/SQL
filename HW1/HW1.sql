create database Hillel 
go 
use Hillel

CREATE TABLE Students
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	City NVARCHAR(30) NULL,
	Country NVARCHAR(30) NULL,
	BirthDay DATE NULL,
	Email NVARCHAR(100) NOT NULL,
	Phone VARCHAR(20) NULL,
	GroupName NVARCHAR(20) NOT NULL,
	AverageGrade DECIMAL(5, 2) NOT NULL,
	SubjectNameWithMinAvarage NVARCHAR(20) NOT NULL,
	SubjectNameWithMaxAvarage NVARCHAR(20) NOT NULL,
);


INSERT INTO dbo.Students 
VALUES 
('Stanislav', 'Gorozhankin', 'Kharkiv', 'Ukraine', '1982-08-17','email@gmail.com' ,'0985554433','SQL', 90.33, 'First','Second'),
('SomeName', 'SomeLastName', NULL, NULL , NULL, 'someEmail@gmail.com' , NULL, 'SomeGroupName', 80.33, 'First','Second');

SELECT * FROM dbo.Students