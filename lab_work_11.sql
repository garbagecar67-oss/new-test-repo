-- Практика 11. Варіант: Бібліотека (читачі бронюють книги)
-- Нова таблиця: reservations (зв'язок "багато-до-багатьох" між books і readers)

-- ============================================================
-- Завдання 1. CREATE TABLE + INSERT
-- ============================================================

CREATE TABLE reservations (
    id INTEGER PRIMARY KEY,
    book_id INTEGER NOT NULL REFERENCES books(id),
    reader_id INTEGER NOT NULL REFERENCES readers(id),
    reservation_date TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('active', 'cancelled', 'completed')),
    notes TEXT
);

INSERT INTO reservations (id, book_id, reader_id, reservation_date, status, notes) VALUES
(1, 1, 1, '2024-01-15', 'active', 'First in queue'),
(2, 1, 2, '2024-02-01', 'active', ''),
(3, 1, 3, '2024-03-10', 'active', ''),
(4, 1, 4, '2024-04-01', 'cancelled', 'Changed mind'),
(5, 2, 1, '2024-05-01', 'active', ''),
(6, 2, 2, '2024-06-15', 'active', ''),
(7, 3, 3, '2024-07-01', 'active', '');

-- ============================================================
-- Завдання 2. JOIN + GROUP BY (COUNT на книгу)
-- ============================================================

SELECT books.title AS book_title, COUNT(reservations.id) AS reservation_count
FROM reservations
JOIN books ON reservations.book_id = books.id
GROUP BY books.id;

-- результат:
-- book_title              reservation_count
-- The Great Gatsby        4
-- 1984                    2
-- To Kill a Mockingbird   1

-- ============================================================
-- Завдання 3. HAVING на COUNT (книги з найбільшою чергою)
-- ============================================================

SELECT books.title AS book_title, COUNT(reservations.id) AS reservation_count
FROM reservations
JOIN books ON reservations.book_id = books.id
GROUP BY books.id
HAVING COUNT(reservations.id) > 2;

-- результат:
-- book_title          reservation_count
-- The Great Gatsby    4

-- ============================================================
-- Завдання 4. WHERE + JOIN + GROUP BY + HAVING (лише активні броні)
-- ============================================================

SELECT books.title AS book_title, COUNT(reservations.id) AS active_reservations
FROM reservations
JOIN books ON reservations.book_id = books.id
WHERE reservations.status = 'active'
GROUP BY books.id
HAVING COUNT(reservations.id) > 2;

-- результат:
-- book_title          active_reservations
-- The Great Gatsby    3

-- ============================================================
-- Завдання 5. Два експерименти і висновок
-- ============================================================

-- (а) рядок-"двійник" у пов'язаній таблиці books
INSERT INTO books (id, title, author, isbn, published_year) VALUES
(5, '1984', 'George Orwell', '9780451524935-DUP', 1949);

-- 2 броні до доданої книги
INSERT INTO reservations (id, book_id, reader_id, reservation_date, status, notes) VALUES
(8, 5, 3, '2024-09-01', 'active', ''),
(9, 5, 4, '2024-09-05', 'active', '');

-- групування за id
SELECT books.id, books.title, COUNT(reservations.id) AS cnt
FROM reservations
JOIN books ON reservations.book_id = books.id
GROUP BY books.id
HAVING COUNT(reservations.id) > 1;

-- результат:
-- id | book_title        | cnt
-- 1  | The Great Gatsby  | 4
-- 2  | 1984              | 2
-- 5  | 1984              | 2

-- групування за назвою
SELECT books.title, COUNT(reservations.id) AS cnt
FROM reservations
JOIN books ON reservations.book_id = books.id
GROUP BY books.title
HAVING COUNT(reservations.id) > 1;

-- результат:
-- book_title        | cnt
-- 1984              | 4
-- The Great Gatsby  | 4

-- (б) LEFT JOIN версія запиту Завдання 4
SELECT books.title AS book_title, COUNT(reservations.id) AS active_reservations
FROM books
LEFT JOIN reservations ON reservations.book_id = books.id
WHERE reservations.status = 'active'
GROUP BY books.id
HAVING COUNT(reservations.id) > 2;

-- результат:
-- book_title          active_reservations
-- The Great Gatsby    3
