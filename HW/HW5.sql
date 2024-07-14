--База данных «Library»

--1. Отобразить книги с минимальным количеством страниц, выпущенные тем или иным издательством.
select b.[Name], b.Pages
from Books b
join Press p
on p.Id = b.Id_Press
where p.[Name] = 'bhv' and [Pages] = (
select min(b.Pages)
from Books b
join Press p
on p.Id = b.Id_Press
where p.[Name] = 'bhv')

--2. Отобразить названия издательств, которые выпустили книги со средним количеством страниц большим 100.
select p.[Name], avg(b.Pages) as AvgPages
from Press p
left join Books b
on b.Id_Press = p.Id
group by p.[Name]
having avg(b.Pages) > 100

--3. Вывести общую сумму страниц всех имеющихся в библиотеке книг, выпущенных издательствами BHV и БИНОМ.
select sum(b.Pages) as SumPages
from Books b
join Press p
on p.Id = b.Id_Press
where p.[Name] = 'bhv' or p.[Name] = N'БИНОМ'

--4. Выбрать имена и фамилии всех студентов, которые брали книги в промежутке между 1 Января 2001 года и текущей датой.
select s.FirstName + s.LastName as Student, b.[Name] as 'Book Name', sc.DateOut, sc.DateIn
from Students s
join S_Cards sc
on sc.Id_Student = s.Id
join Books b
on b.Id = sc.Id_Book
where sc.DateOut > '2001/01/01'

--5. Найти всех студентов, кто на данный момент работает с книгой "Реестр Windows 2000" автора Ольга Кокорева.
select s.FirstName + s.LastName as Student, b.[Name] as 'Book Name', a.FirstName + a.LastName as Athor
from Students s
join S_Cards c
on c.Id_Student = s.Id
join Books b
on b.Id = c.Id_Book
join Authors a
on a.Id = b.Id_Author
where a.FirstName = N'Ольга' and a.LastName= N'Кокорева' and b.[Name]=N'Реестр Windows 2000'

--6. Отобразить информацию об авторах, средний объем книг которых (в страницах) более 600 страниц.
select a.FirstName + ' ' + a.LastName as Athor
from Authors a
left join Books b
on b.Id_Author = a.Id
group by a.FirstName, a.LastName
having avg(b.Pages) > 600

--7. Отобразить информацию об издательствах, у которых общее количество страниц выпущенных ими книг больше 700.
select p.[Name]
from Press p
left join Books b
on b.Id_Press = p.Id
group by p.[Name]
having sum(b.Pages*Quantity) > 700

--8. Отобразить всех посетителей библиотеки (и студентов и преподавателей) и книги, которые они брали.
select 'Student' as VisitorType, s.FirstName as VisitorFirstName, s.LastName as VisitorLastName,
	b.[Name] as BookName, b.Pages, b.YearPress, sc.DateOut, sc.DateIn
from Students s
join S_Cards sc 
on s.Id = sc.Id_Student
join Books b 
on SC.Id_Book = b.Id
union
select 'Teacher' as VisitorType, t.FirstName as VisitorFirstName, t.LastName as VisitorLastName, b.[Name] as BookName,
	b.Pages, b.YearPress, tc.DateOut, tc.DateIn 
	from Teachers t
join T_Cards tc 
on t.Id = tc.Id_Teacher
join Books b 
on tc.Id_Book = b.Id
order by
	VisitorType, VisitorLastName, VisitorFirstName, BookName;

--9. Вывести самого популярного автора(ов) среди студентов и количество книг этого автора, взятых в библиотеке.
with StudentBookCounts as (
	select b.Id_Author, count(*) as BookCount
	from S_Cards sc
	join Books b 
	on sc.Id_Book = b.Id
	group by b.Id_Author
),
MaxBookCount as (
	select max(BookCount) as MaxCount
	from StudentBookCounts
)
select a.FirstName, a.LastName, sbc.BookCount
from StudentBookCounts sbc
join Authors a 
on sbc.Id_Author = A.Id
join MaxBookCount mbc 
on sbc.BookCount = mbc.MaxCount;

--10. Вывести самого популярного автора(ов) среди преподавателей и количество книг этого автора, взятых в библиотеке.
with TeracherBookCounts as (
	select b.Id_Author,	count(*) as BookCount
	from T_Cards tc
	join Books b 
	on tc.Id_Book = b.Id
	group by b.Id_Author
),
MaxBookCount as (
	select max(BookCount) as MaxCount
	from TeracherBookCounts
)
select 
	a.FirstName,
	a.LastName,
	tbc.BookCount
from 
	TeracherBookCounts tbc
join 
	Authors a on tbc.Id_Author = A.Id
join
	MaxBookCount mbc on tbc.BookCount = mbc.MaxCount;

--11. Вывести самую популярную(ые) тематику(и) среди студентов и преподавателей.
select top 1 with TIES 
	t.[Name] AS Theme,
	count(sc.Id_Book) as BookCount
from
	S_Cards sc
join 
	Books b on sc.Id_Book = b.Id
join
	Themes t on b.Id_Themes = t.Id
group by 
	t.[Name]
order by
	BookCount desc

select top 1 with TIES 
	t.[Name] as Theme,
	count(tc.Id_Book) as BookCount
from
	T_Cards tc
join 
	Books b on tc.Id_Book = b.Id
join
	Themes t on b.Id_Themes = t.Id
group by
	t.[Name]
order by
	BookCount desc

--12. Отобразить количество преподавателей и студентов, посетивших библиотеку.
select count(distinct Id_Student) as 'Pepople Count', 'Student' as VisitorType
from S_Cards
union
select count(distinct Id_Teacher), 'Teacher'
from T_Cards;

--13. Если считать общее количество книг в библиотеке за 100%, то необходимо подсчитать, сколько книг (в процентном отношении) брал каждый факультет.
with TotalBooks as (
	select count(*) as TotalBooks
	from Books
), 
FacultyBooks as (
	select f.[Name], count(*) AS BooksTakenByFaculty
	from S_Cards sc
	join dbo.Students s ON s.Id = sc.Id_Student
	join dbo.Groups g ON g.Id = s.Id_Group
	join dbo.Faculties f 
	on g.Id_Faculty = f.Id
	group by f.[Name]
)
select fb.[Name], fb.BooksTakenByFaculty,
	(fb.BooksTakenByFaculty * 100.0 / tb.TotalBooks) AS PercentageBooksTaken
from FacultyBooks fb, TotalBooks tb

--14. Отобразить самый читающий факультет и самую читающую кафедру.
select top 1 f.[Name], count(sc.Id_Book)
from Faculties f
join Groups g
on g.Id_Faculty = f.Id
join Students s
on s.Id_Group = g.Id
join S_Cards sc
on sc.Id_Student = s.Id
group by f.[Name] 
order by count(sc.Id_Book) desc

--15. Показать автора (ов) самых популярных книг среди преподавателей и студентов.
select top 1 with TIES count(*) as 'Book count', a.FirstName, a.LastName, t1.bookId
from 
(select Id_Book as  bookId
from T_Cards tc
union all
select Id_Book
from S_Cards sc) t1
left join Books b
on b.Id = t1.bookId
left join Authors a
on a.Id = b.Id_Author
group by t1.bookId, a.FirstName, a.LastName
order by count(*) desc

--16. Отобразить названия самых популярных книг среди преподавателей и студентов.
select top 1 with TIES count(*) as 'Book count', b.[Name], t1.bookId
from 
(select Id_Book as  bookId
from T_Cards tc
union all
select Id_Book
from S_Cards sc) t1
left join Books b
on b.Id = t1.bookId
group by t1.bookId, b.[Name]
order by count(*) desc

--17. Показать всех студентов и преподавателей дизайнеров.
select t.FirstName, t.LastName, d.[Name], 'Teacher' as VisitorType
from Teachers t
join Departments d
on d.Id = t.Id_Dep
where d.[Name] = N'Графики и Дизайна'
union
select s.FirstName, s.LastName, f.[Name], 'Student' as VisitorType
from Students s
join Groups g
on g.Id = s.Id_Group
join Faculties f
on f.Id = g.Id_Faculty
where f.[Name] = N'Веб-дизайна'
order by VisitorType

--18. Показать всю информацию о студентах и преподавателях, бравших книги.
select s.FirstName, s.LastName, sc.DateOut, sc.DateIn, b.[Name], 'Student' as VisitorType
from Students s
join S_Cards sc
on sc.Id_Student = s.Id
join Books b
on b.Id = sc.Id_Book
union
select t.FirstName, t.LastName, tc.DateOut, tc.DateIn, b.[Name],'Teacher' as VisitorType
from Teachers t
join T_Cards tc
join Books b
on b.Id = tc.Id_Book
on tc.Id_Teacher = t.Id

--19. Показать книги, которые брали и преподаватели и студенты.
select b.[Name]
from Books b
join T_Cards tc
on tc.Id_Book = b.Id
join S_Cards sc
on sc.Id_Book = b.Id
group by b.[Name]

--20. Показать сколько книг выдал каждый из библиотекарей.
select lib.FirstName, lib.LastName, t1.bookCount + t2.bookCount as BookCount
from 
	(select l.Id, count(tc.Id_Book) as bookCount
	from Libs l
	join T_Cards tc
	on tc.Id_Lib = l.Id
	group by l.Id) t1
join 
	(select l.Id, count(sc.Id_Book) as bookCount
	from Libs l
	join S_Cards sc
	on sc.Id_Lib = l.Id
	group by l.Id) t2
on t1.Id = t2.Id
join Libs lib
on lib.Id = t1.Id
