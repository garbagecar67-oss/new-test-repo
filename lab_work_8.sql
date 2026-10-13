-- Практика 8. Застосування агрегатних функцій
-- Варіант: Бібліотека (читачі бронюють книги)

-- ============================================================
-- Завдання 1. COUNT(*) проти COUNT(колонка)
-- ============================================================
-- Цолонка return_date у таблиці loans може бути NULL.
-- Якщо числовий результат COUNT(*) і COUNT(return_date) відрізняється,
-- це свідчить про наявність NULL-значень.

SELECT COUNT(*) AS total_rows FROM loans;
-- Result: total_rows = 9

SELECT COUNT(return_date) AS non_null_rows FROM loans;
-- Result: non_null_rows = 5

-- У базі 4 рядки мають NULL у колонці return_date (книги, що ще не повернули).
-- Коли б всі return_date були NOT NULL, числа би співпадали.

-- ============================================================
-- Завдання 2. SUM і AVG на числовій колонці
-- ============================================================
-- Використовуємо published_year з таблиці books (вимірна таблиця).

SELECT SUM(published_year) AS total_years, AVG(published_year) AS average_year FROM books;
-- Result: total_years = 9596, average_year = 1919.2

-- У контексті бібліотеки: SUMSUM — це сумарно років видання всіх книг;
-- AVG — це середній рік видання на книгу.

-- ============================================================
-- Завдання 3. MIN/MAX на текстовій колонці
-- ============================================================
-- Використовуємо назву книги (title) з таблиці books.

SELECT MIN(title) AS first_alphabetically, MAX(title) AS last_alphabetically FROM books;
-- Result: first_alphabetically = 1984, last_alphabetically = To Kill a Mockingbird

-- СУБД сортує текстове значення за кодовою таблицею (ASCII/Unicode),
-- тому '1984' йде першим, а 'To Kill a Mockingbird' — останнім.

-- ============================================================
-- Завдання 4. Кілька агрегатних функцій в одному запиті
-- ============================================================
-- Обчислюємо COUNT, SUM, AVG, MIN, MAX у одному SELECT над фактовою таблицею loans
-- з JOIN до books для одразу кількох метрик.

SELECT 
    COUNT(*) AS total_loans,
    COUNT(return_date) AS returned_loans,
    SUM(published_year) AS sum_pub_year,
    AVG(published_year) AS avg_pub_year,
    MIN(published_year) AS min_pub_year,
    MAX(published_year) AS max_pub_year
FROM loans
JOIN books ON loans.book_id = books.id;
-- Result: total_loans = 9, returned_loans = 5,
--         sum_pub_year = 17456, avg_pub_year = 1939.5555,
--         min_pub_year = 1925, max_pub_year = 1960

-- ============================================================
-- Завдання 5. Агрегат + WHERE
-- ============================================================
-- Фільтруємо за назвою книги '1984' з вимірної таблиці books.

SELECT 
    COUNT(*) AS total_loans,
    COUNT(return_date) AS returned_loans
FROM loans
JOIN books ON loans.book_id = books.id
WHERE books.title = '1984';
-- Result: total_loans = 4, returned_loans = 2

-- Чому результат змінився: WHERE прибрав із розрахунку лоани,
-- що стосуються книги з назвою '1984' (кількість таких книг у базі — 4 шт.,
-- з них 2 вже повернуто, 2 ще у наявності).