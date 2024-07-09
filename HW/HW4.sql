create database HW4 
go

use HW4 
go

CREATE TABLE Currency
(
	[Id] INT CONSTRAINT PK_Currency_Id PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
)

CREATE TABLE Continent
(
	[Id] INT CONSTRAINT PK_Continent_Id PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
)

CREATE TABLE Country
(
	[Id] INT CONSTRAINT PK_Country_Id PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
	[ContinentId] INT,
	[CurrencyId] INT,
	[Capital] NVARCHAR(50) NOT NULL,
	[Territory] FLOAT NOT NULL,
	[Debut] BIT NOT NULL,
	[Champion] INT NULL,
	CONSTRAINT FK_Country_To_Continent FOREIGN KEY ([ContinentId])  REFERENCES Continent ([Id]),
	CONSTRAINT FK_Country_To_Currency FOREIGN KEY ([CurrencyId])  REFERENCES Currency ([Id])
)

CREATE TABLE [Language]
(
	[Id] INT CONSTRAINT PK_Language_Id PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
)

CREATE TABLE [CountryLanguage]
(
	[Id] INT CONSTRAINT PK_CountryLanguage_Id PRIMARY KEY IDENTITY,
	[CountryId] INT,
	[LanguageId] INT,
	CONSTRAINT FK_CountryLanguage_To_Country FOREIGN KEY ([CountryId])  REFERENCES Country ([Id]),
	CONSTRAINT FK_CountryLanguage_To_Language FOREIGN KEY ([LanguageId])  REFERENCES [Language] ([Id]),
)

--Темы:
--- Многотабличные запросы к базе данных «Teams».
--- Агрегатные функции. 
--- Вложенные запросы.

--1. Отобразить страну, которая чаще других становилась чемпионом мира.
select top 1 [Name], Champion
from Country
order by Champion desc

--2. Отобразить количество стран, представленное каждым континентом на чемпионате мира.
select count(*) as [Count], (select [Name] from Continent where Id = Country.ContinentId) as [Name]
from Country
group by ContinentId

--3. Отобразить европейскую страну, которая чаще других становилась чемпионом мира.
select top 1 [Name], Champion
from Country
where ContinentId = (select Id from Continent where [Name] = N'Европа')
order by Champion desc

--4. Отобразить страну, территория которой наибольшая.
select top 1 [Name], Territory
from Country
order by Territory desc
--5. Отобразить европейскую страну, территория которой наибольшая.
select top 1 [Name], Territory
from Country
where ContinentId = (select Id from Continent where [Name] = N'Европа')
order by Territory desc

select top 1 [Name], Territory
from Country
order by ContinentId, Territory desc

--6. Отобразить по каждому континенту количество стран, которые становились чемпионами мира.
select (select [Name] from Continent where Id = Country.ContinentId) as [Name], count(*) as ChampionCount
from Country
where Champion > 0
group by ContinentId

--7. Отобразить для каждого континента суммарное количество чемпионских титулов.
select (select [Name] from Continent where Id = Country.ContinentId) as [Name], sum(Champion) as ChampionSum
from Country
group by ContinentId

--8. Определить по каждому континенту среднее значение территории для стран, входящих в этот континент.
select (select [Name] from Continent where Id = Country.ContinentId) as [Name], avg(Territory) as AvgTerritory
from Country
group by ContinentId

--9. Отобразить количество стран-дебютантов для каждого континента.
select (select [Name] from Continent where Id = Country.ContinentId) as [Name], count(Debut) as DebutCount
from Country
where Debut > 0
group by ContinentId

--10. Отобразить для каждого языка количество стран, в которых этот язык является официальным.
select (select [Name] from [Language] where Id = t1.LanguageId) as [Name], count(*) as CountryCount
from CountryLanguage as t1
group by LanguageId

--11. Отобразить африканскую страну, территория которой наименьшая.
select top 1 [Name], Territory
from Country
where ContinentId = (select Id from Continent where [Name] = N'Африка')
order by Territory asc

--12. Отобразить для каждой валюты количество стран, в которых эта валюта является национальной.
select [Name], (select count(*) from Country where CurrencyId = t1.Id) as CountryCount
from Currency as t1

--13. Отобразить наиболее распространенный язык и указать количество стран, в которых он является официальным.
select top 1 (select [Name] from [Language] where Id = t1.LanguageId) as [Name], count(*) as CountryCount
from CountryLanguage as t1
group by LanguageId
order by CountryCount desc

--14. Отобразить континент, у которого самый высокий суммарный показатель по чемпионским титулам.
select [Name] 
from [Language]
where Id = (
	select top 1 cl.LanguageId
	from Country c
	join CountryLanguage cl 
		on c.Id = cl.CountryId
	join Continent co 
		on c.ContinentId = co.Id
	where co.[Name] IN (N'Африка',  N'Европа')
	group by cl.LanguageId
	order by count(cl.CountryId) desc)