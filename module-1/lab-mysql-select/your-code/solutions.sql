-- CHALLENGE 1 --

SELECT authors.au_id AS "Author ID", authors.au_lname AS "Last Name", authors.au_fname AS "First Name", titles.title AS "Title", publishers.pub_name AS "Publisher"
FROM authors
INNER JOIN titleauthor on authors.au_id = titleauthor.au_id
INNER JOIN titles on titleauthor.title_id = titles.title_id
INNER JOIN publishers on publishers.pub_id = titles.pub_id;

-- CHALLENGE 2 --

SELECT authors.au_id AS "Author ID", authors.au_lname AS "Last Name", authors.au_fname AS "First Name", COUNT(titles.title) AS "Nb of Titles", publishers.pub_name AS "Publisher"
FROM authors
INNER JOIN titleauthor on authors.au_id = titleauthor.au_id
INNER JOIN titles on titleauthor.title_id = titles.title_id
INNER JOIN publishers on publishers.pub_id = titles.pub_id
GROUP BY authors.au_id
ORDER BY authors.au_lname;

-- CHALLENGE 3 --

SELECT authors.au_id AS "Author ID", authors.au_lname AS "Last Name", authors.au_fname AS "First Name", SUM(sales.qty) AS "Nb of sales"
FROM authors
INNER JOIN titleauthor on authors.au_id = titleauthor.au_id
INNER JOIN titles on titleauthor.title_id = titles.title_id
INNER JOIN sales on sales.title_id = titles.title_id
GROUP BY authors.au_id
ORDER BY sum(sales.qty) DESC
LIMIT 3;

-- CHALLENGE 4 --

SELECT authors.au_id AS "Author ID", authors.au_lname AS "Last Name", authors.au_fname AS "First Name", SUM(ifnull(sales.qty,0)) AS "Nb of sales"
FROM authors
LEFT OUTER JOIN titleauthor on authors.au_id = titleauthor.au_id
LEFT OUTER JOIN titles on titleauthor.title_id = titles.title_id
LEFT OUTER JOIN sales on sales.title_id = titles.title_id
GROUP BY authors.au_id
ORDER BY sum(sales.qty) DESC;

-- BONUS --

