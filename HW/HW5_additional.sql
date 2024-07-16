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
--- Доп задание переписать все используя джоины

--1. Отобразить страну, которая чаще других становилась чемпионом мира.
select top 1 [Name], Champion
from Country
order by Champion desc

--2. Отобразить количество стран, представленное каждым континентом на чемпионате мира.
select (select [Name] from Continent where Id = Country.ContinentId) as [Name], count(*) as [Count]
from Country
group by ContinentId
order by [Count] desc

select co.[Name], count(*) as [Count]
from Country c
join Continent co
on co.Id = c.ContinentId
group by co.[Name]
order by [Count] desc


--3. Отобразить европейскую страну, которая чаще других становилась чемпионом мира.
select top 1 [Name], Champion
from Country
where ContinentId = (select Id from Continent where [Name] = N'Европа')
order by Champion desc

select top 1 c.[Name], c.Champion
from Country c
join Continent co
on co.Id = c.ContinentId
where co.[Name] =  N'Европа'
order by Champion desc

--4. Отобразить страну, территория которой наибольшая.
select [Name], Territory
from Country
where Territory = (select Max(Territory)
					from Country)

--5. Отобразить европейскую страну, территория которой наибольшая.
select top 1 [Name], Territory
from Country
where ContinentId = (select Id from Continent where [Name] = N'Европа')
order by Territory desc

select c.[Name]
from Country c
where Territory = (
select Max(c.Territory)
from Country c
join Continent co
on co.Id = c.ContinentId
where co.[Name] = N'Европа')

--6. Отобразить по каждому континенту количество стран, которые становились чемпионами мира.
select (select [Name] from Continent where Id = Country.ContinentId) as [Name], count(*) as ChampionCount
from Country
where Champion > 0
group by ContinentId

select co.[Name], COUNT(*) as ChampionCount
from Continent co
join Country c
on c.ContinentId = co.Id
where c.Champion > 0
group by co.[Name]

--7. Отобразить для каждого континента суммарное количество чемпионских титулов.
select (select [Name] from Continent where Id = Country.ContinentId) as [Name], sum(Champion) as ChampionSum
from Country
group by ContinentId

select co.[Name], sum(c.Champion)as ChampionSum
from Continent co
join Country c
on co.Id = c.ContinentId
group by co.[Name]

--8. Определить по каждому континенту среднее значение территории для стран, входящих в этот континент.
select (select [Name] from Continent where Id = Country.ContinentId) as [Name], avg(Territory) as AvgTerritory
from Country
group by ContinentId
order by [Name]

select co.[Name], avg(c.Territory)as AvgTerritory
from Continent co
join Country c
on co.Id = c.ContinentId
group by co.[Name]
order by co.[Name]

--9. Отобразить количество стран-дебютантов для каждого континента.
select (select [Name] from Continent where Id = Country.ContinentId) as [Name], count(Debut) as DebutCount
from Country
where Debut > 0
group by ContinentId
order by [Name]

select co.[Name], count(c.Debut)as DebutCount
from Continent co
join Country c
on co.Id = c.ContinentId
where Debut > 0
group by co.[Name]
order by co.[Name]

--10. Отобразить для каждого языка количество стран, в которых этот язык является официальным.
select (select [Name] from [Language] where Id = t1.LanguageId) as [Name], count(*) as CountryCount
from CountryLanguage as t1
group by LanguageId
order by [Name]

select l.[Name], count(cl.LanguageId) as CountryCount
from CountryLanguage cl
join [Language] l
on l.Id = cl.LanguageId
join Country c
on c.Id = cl.CountryId
group by l.[Name]

--11. Отобразить африканскую страну, территория которой наименьшая.
select top 1 [Name], Territory
from Country
where ContinentId = (select Id from Continent where [Name] = N'Африка')
order by Territory asc;

select c.[Name]
from Continent co
join Country c
on c.ContinentId = co.Id
where c.Territory = (
	select min(c.Territory)
	from Country c
	join Continent co
	on co.Id = c.ContinentId
	where co.[Name] = N'Африка')

--12. Отобразить для каждой валюты количество стран, в которых эта валюта является национальной.
select [Name], (select count(*) from Country where CurrencyId = t1.Id) as CountryCount
from Currency as t1
order by [Name]

select cu.[Name], COUNT(*)
from Currency cu
join Country c
on c.CurrencyId = cu.Id
group by cu.[Name]

--13. Отобразить наиболее распространенный язык и указать количество стран, в которых он является официальным.
select top 1 (select [Name] from [Language] where Id = t1.LanguageId) as [Name], count(*) as CountryCount
from CountryLanguage as t1
group by LanguageId
order by CountryCount desc

select top 1 l.[Name] AS LanguageName, COUNT(cl.CountryId) as NumberOfCountries
from [Language] l
join CountryLanguage cl on l.Id = cl.LanguageId
group by l.[Name]
order by NumberOfCountries desc;

--14. Отобразить континент, у которого самый высокий суммарный показатель по чемпионским титулам.
select top 1 c.[Name] as ContinentName, sum(co.Champion) as TotalChampionshipTitles
from Continent c
join Country co on c.Id = co.ContinentId
group by c.[Name]
order by TotalChampionshipTitles desc;


--15. Отобразить наиболее распространенный язык среди стран европейского и африканского континентов.
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

select top 1 l.[Name]
from Country c
join CountryLanguage cl 
	on c.Id = cl.CountryId
join Continent co 
	on c.ContinentId = co.Id
join [Language] l
	on l.Id = cl.LanguageId
where co.[Name] IN (N'Африка',  N'Европа')
group by cl.LanguageId, l.[Name]
order by count(cl.CountryId) desc