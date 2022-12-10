/*
use book_library database
*/

/*
01.Find Book Titles
*/

SELECT `title` FROM `books`
WHERE substring(`title`, 1, 3) = 'The';

/*
02.Replace Titles
*/

SELECT replace(`title`, 'The', '***') AS 'title' FROM `books`
WHERE substring(`title`, 1, 3) = 'The';

/*
03.Sum Cost of All Books
*/

SELECT round(sum(`cost`), 2) FROM `books`;

/*
04.Days Lived
*/

SELECT concat_ws(' ', `first_name`, `last_name`) AS 'Full Name', timestampdiff(DAY, `born`, `died`) AS 'Days Lived ' FROM `authors`;

/*
05.Harry Potter Books
*/

SELECT `title` FROM `books`
WHERE `title` LIKE 'Harry Potter%'
ORDER BY `id`;
