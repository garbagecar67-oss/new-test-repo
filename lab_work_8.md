# Практична 8 | Test User | 1 | Програмування

## Завдання 1. COUNT(*) проти COUNT(колонка)

Результати:

```
SELECT COUNT(*) FROM loans;              -> 9
SELECT COUNT(return_date) FROM loans;    -> 5
```

COUNT(*) пораховує всі рядки (9), а COUNT(return_date) — тільки ті, де повернуто дату.
Якщо б усі return_date були NOT NULL, числа співпали б. У базі 4 рядки мають NULL
у цій колонці (книги, які ще не повернули), тому COUNT(return_date) = 5 < COUNT(*).

## Завдання 2. SUM і AVG на числовій колонці

Результати:

```
SELECT SUM(published_year), AVG(published_year) FROM books;
-> SUM(published_year) = 9596
-> AVG(published_year) = 1919.2
```

Середній рік видання книги з фонду — 1919.2. Це означає, що середня дата видання
книг на обліку — 1919 рік (середнє арифметичне років видання).

## Завдання 3. MIN/MAX не лише на числах

Результати:

```
SELECT MIN(title), MAX(title) FROM books;
-> MIN(title) = 1984
-> MAX(title) = To Kill a Mockingbird
```

Тут MIN/MAX працюють над текстовою колонкою, замість числової. СУБД визначає
«найменше»/«найбільше» значення за кодовою таблицею (ASCII/Unicode) —
порівнює символи за їх кодовими значеннями, тому рядок починається з цифр
і йде раніше за букви.

## Завдання 4. Кілька агрегатних функцій в одному запиті

Результати:

```
SELECT COUNT(*) AS total_loans,
       COUNT(return_date) AS returned_loans,
       SUM(published_year) AS sum_pub_year,
       AVG(published_year) AS avg_pub_year,
       MIN(published_year) AS min_pub_year,
       MAX(published_year) AS max_pub_year
FROM loans
JOIN books ON loans.book_id = books.id;

-> total_loans = 9
-> returned_loans = 5
-> sum_pub_year = 17456
-> avg_pub_year = 1939.5555
-> min_pub_year = 1925
-> max_pub_year = 1960
```

Один запит дає «звіт» на весь набір даних: всього лоанів, кількість повернутих,
сумарний/середній/мінімальний/максимальний рік видання книг.

## Завдання 5. Агрегат + WHERE

Результати:

```
SELECT COUNT(*) AS total_loans, COUNT(return_date) AS returned_loans
FROM loans
JOIN books ON loans.book_id = books.id
WHERE books.title = '1984';

-> total_loans = 4, returned_loans = 2
```

WHERE відсіяв усі рядки, крім тих, що стосуються книги з назвою '1984',
і агрегатні функції порахували тільки цю підмножину лоанів (4 всього,
2 вже повернуто).

## Контрольні питання

**1. Чому COUNT(*) і COUNT(колонка) можуть повернути різні числа, а COUNT(*) і
COUNT(id) — практично завжди однакові?**

COUNT(*) бере до уваги кожен рядок таблиці, навіть якщо всі колонки NULL.
COUNT(колонка) пропускає рядки, де значення у цій колонці NULL. Тому COUNT(*)
і COUNT(колонка) відрізняються тоді, коли в колонці є NULL-значення (як
COUNT(*) vs COUNT(return_date) тут: 9 проти 5).

COUNT(*) і COUNT(id) майже завжди однакові, якщо id — первинний ключ,
бо первинний ключ не може містити NULL-значень (обов'язкова умова).

**2. Якби в таблиці було 5 рядків із числовою колонкою, і в одному з них
значення NULL, чому дорівнював би знаменник при обчисленні AVG — 5 чи 4?**

Знаменник — 4. AVG обчислюється як SUM(колонка) / COUNT(колонка), а
COUNT(колонка) не включає NULL-значення. Тому ділення відбувається на 4.

**3. SUM(колонка), якщо всі рядки мають NULL:**

```
SELECT SUM(published_year) FROM books WHERE published_year IS NULL;
-> NULL
```

Якщо всі рядки мають NULL у колонці, SUM повертає NULL, а не 0.
COUNT(*) = 0, COUNT(col) = 0, AVG = NULL, MIN/MAX = NULL, але SUM = NULL.