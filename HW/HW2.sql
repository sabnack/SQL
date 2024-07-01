USE Hillel

GO

--Selecting all rows from Students
SELECT * FROM dbo.Students

--Selecting FirstName, LastName from Students
SELECT FirstName + ' ' + LastName AS FIO FROM dbo.Students

--Selecting AverageGrade from Students
SELECT AverageGrade FROM dbo.Students 

--We make a unique selection of the country field.
SELECT DISTINCT Country FROM dbo.Students 

--We make a unique selection of the City field.
SELECT DISTINCT City FROM dbo.Students 

--We make a unique selection of the GroupName field.
SELECT DISTINCT GroupName FROM dbo.Students 


--Additional
USE [Database_Books]
GO
-- Написать запросы:
SELECT * FROM [dbo].[books]
-- 1. Отобразить список авторов книг без повторений. Отсортировать по возрастанию.
SELECT DISTINCT Author FROM [dbo].[books] 
ORDER BY [Author] ASC
-- 2. Отобразить книги по программированию издательств «Наука» и «BHV».
SELECT [Name] FROM [dbo].[books] 
WHERE [Press] = N'Наука' OR [Press] = 'BHV'
-- 3. Отобразить все книги, у которых количество страниц лежит в пределах от 200 до 600.
SELECT [Name] FROM [dbo].[books] 
WHERE [Pages] > 200 AND [Pages] < 600
-- 4. Отобразить все книги, имена авторов которых лежат в диапазоне от буквы 'В' до 'О'. Отсортировать по возрастанию (по авторам).
SELECT [Name], [Author] FROM [dbo].[books] 
WHERE Author LIKE N'[В-Ов-о]%'
ORDER BY [Author] ASC
-- 5. Выбрать книги, относящиеся к программированию или к базам данных, и издательства которых не 'Наука' и не 'Бином'.
SELECT [Name], [Themes], [Press] FROM [dbo].[books] 
WHERE ([Themes] = N'Программирование' OR  [Themes] =  N'Базы данных') AND ([Press] = N'Наука' OR  [Press] =  N'Бином')
-- 6. Выбрать из таблицы тех авторов (без повторений), у которых в имени и фамилии не менее двух букв 'а'.
SELECT DISTINCT [Author]
FROM [dbo].[books]
WHERE (
  LEN([Author]) - LEN(REPLACE(LOWER([Author]), N'а', ''))
) >= 2;
-- 7. Отобразить всех авторов и их книги. Авторов отсортировать по возрастанию, а названия книг (по авторам) по убыванию (вторичная сортировка).
SELECT [Author],[Name] FROM [dbo].[books] 
ORDER BY [Author] ASC ,[Name] DESC
-- 8. Выбрать из таблицы книги, названия которых начинаются с цифры.
SELECT [Name] FROM [dbo].[books] 
WHERE [Name] LIKE '[0-9]%'
-- 9. Выбрать из таблицы книги, названия которых заканчиваются на четыре цифры.
SELECT [Name] FROM [dbo].[books] 
WHERE [Name] LIKE '%[0-9][0-9][0-9][0-9]'
-- 10. Выбрать из таблицы книги, в названиях которых ровно две цифры.

-- 11. Выбрать из таблицы книги, которые имеются в наличии в единственном экземпляре. Отсортировать по возрастанию.
SELECT [Name] FROM [dbo].[books] 
WHERE [Quantity] = 1
ORDER BY [Name] ASC
-- 12. Выбрать из таблицы книги по программированию, не относящиеся к издательству «BHV», в названиях которых есть слово «Visual».
SELECT [Name], [Press], [Themes] FROM [dbo].[books] 
WHERE [Themes] = N'Программирование' AND [Press] <> 'BHV' AND [Name] like '%Visual%'
-- 13. Отобразить книги по программированию и Web-дизайну, которые относятся к издательствам «BHV» и «Бином».
SELECT [Name], [Themes], [Press] FROM [dbo].[books] 
WHERE ([Themes] = N'Программирование' OR  [Themes] = N'Web-дизайн') AND ([Press] = 'BHV' OR  [Press] =  N'Бином')
-- 14. Выбрать книги, являющиеся справочниками или руководством.
SELECT [Name], [Comment] FROM [dbo].[books] 
WHERE [Comment] LIKE N'Справочник%' OR [Comment] LIKE N'Руководство%'
-- 15. Отобразить книги, названия которых начинаются на английскую букву.
SELECT [Name] FROM [dbo].[books] 
WHERE [Name] LIKE '[A-Za-z]%'
