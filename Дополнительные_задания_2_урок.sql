﻿USE [master]
GO
CREATE DATABASE [Database_Books]
GO
USE [Database_Books]
GO
CREATE TABLE [dbo].[books](
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Name] [nvarchar](100) NULL,
	[Pages] [int] NULL,
	[YearPress] [int] NULL,
	[Themes] [nvarchar](50) NULL,
	[Author] [nvarchar](50) NULL,
	[Press] [nvarchar](50) NULL,
	[Comment] [nvarchar](50) NULL,
	[Quantity] [int] NULL
) ON [PRIMARY]
GO
INSERT [dbo].[books] ([Name], [Pages], [YearPress], [Themes], [Author], [Press], [Comment], [Quantity]) VALUES 
(N'SQL', 816, 2001, N'Базы данных', N'Грофф', N'BHV', N'2-е издание', 2)
,(N'3D Studio Max 3', 640, 2000, N'Графические пакеты', N'Маров', N'Питер', N'Учебный курс', 3)
,(N'100 компонентов общего назначения библиотеки Delphi 5', 272, 1999, N'Программирование', N'Архангельский', N'Бином', N'Компоненты', 1)
,(N'Курс математического анализа', 328, 1990, N'Высшая математика', N'Никольский', N'Наука', N'1-й том', 1)
,(N'Библиотека C++ Builder 5: 70 компонентов ввода/вывода информации', 288, 2000, N'Программирование', N'Архангельский', N'Бином', N'Компоненты', 1)
,(N'Интегрированная среда разработки', 272, 2000, N'Программирование', N'Архангельский', N'Бином', N'Среда разработки', 2)
,(N'Visual Basic 6.0 for Application', 488, 2000, N'Программирование', N'Король', N'DiaSoft', N'Справочник с примерами', 3)
,(N'Visual Basic 6', 576, 2000, N'Программирование', N'Петрусос', N'BHV', N'Руководство разработчика 1-й том', 1)
,(N'Mathcad 2000', 416, 2000, N'Математические пакеты', N'Херхагер', N'BHV', N'Полное руководство', 1)
,(N'Novell GroupWise 5.5 система электронной почты и коллективной работы', 480, 2000, N'Сети', N'Гарбар', N'BHV', N'Сетевые пакеты', 2)
,(N'Реестр Windows 2000', 352, 2000, N'Операционные системы', N'Кокорева', N'BHV', N'Руководство для профессионалов', 4)
,(N'Самоучитель Visual FoxPro 6.0', 512, 1999, N'Базы данных', N'Омельченко', N'BHV', N'Самоучитель', 1)
,(N'Самоучитель FrontPage 2000', 512, 1999, N'Web-дизайн', N'Омельченко', N'BHV', N'Самоучитель', 1)
,(N'Самоучитель Perl', 432, 2000, N'Программирование', N'Матросов', N'BHV', N'Самоучитель', 2)
,( N'HTML 3.2', 1040, 2000, N'Web-дизайн', N'Браун', N'BHV', N'Руководство', 5)

-- Написать запросы:
select * from dbo.books
-- 1. Отобразить список авторов книг без повторений. Отсортировать по возрастанию.
-- 2. Отобразить книги по программированию издательств «Наука» и «BHV».
-- 3. Отобразить все книги, у которых количество страниц лежит в пределах от 200 до 600.
-- 4. Отобразить все книги, имена авторов которых лежат в диапазоне от буквы 'В' до 'О'. Отсортировать по возрастанию (по авторам).
-- 5. Выбрать книги, относящиеся к программированию или к базам данных, и издательства которых не 'Наука' и не 'Бином'.
-- 6. Выбрать из таблицы тех авторов (без повторений), у которых в имени и фамилии не менее двух букв 'а'.
-- 7. Отобразить всех авторов и их книги. Авторов отсортировать по возрастанию, а названия книг (по авторам) по убыванию (вторичная сортировка).
-- 8. Выбрать из таблицы книги, названия которых начинаются с цифры.
-- 9. Выбрать из таблицы книги, названия которых заканчиваются на четыре цифры.
-- 10. Выбрать из таблицы книги, в названиях которых ровно две цифры.
-- 11. Выбрать из таблицы книги, которые имеются в наличии в единственном экземпляре. Отсортировать по возрастанию.
-- 12. Выбрать из таблицы книги по программированию, не относящиеся к издательству «BHV», в названиях которых есть слово «Visual».
-- 13. Отобразить книги по программированию и Web-дизайну, которые относятся к издательствам «BHV» и «Бином».
-- 14. Выбрать книги, являющиеся справочниками или руководством.
-- 15. Отобразить книги, названия которых начинаются на английскую букву.

