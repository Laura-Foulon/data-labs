-- Advanced MySQL LAB --
-- Step 1: Calculate the royalties of each sales for each author --

SELECT titles.title_id AS 'TITLE ID', authors.au_id AS 'AUTHOR ID', COALESCE((titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100), 0) AS 'sales_royalty' 
FROM authors
INNER JOIN titleauthor ON authors.au_id = titleauthor.au_id
LEFT JOIN titles ON titleauthor.title_id= titles.title_id
LEFT JOIN sales ON titles.title_id = sales.title_id;

-- Step 2 : Aggregate the total royalties for each title for each author --

SELECT TITLE_ID, AUTHOR_ID, SUM(sales_royalty) AS 'total_royalty'
FROM 
(
SELECT titles.title_id AS 'TITLE_ID', authors.au_id AS 'AUTHOR_ID', COALESCE((titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100), 0) AS 'sales_royalty' 	
FROM authors
INNER JOIN titleauthor ON authors.au_id = titleauthor.au_id
LEFT JOIN titles ON titleauthor.title_id = titles.title_id
LEFT JOIN sales ON titles.title_id = sales.title_id
) summary
GROUP BY TITLE_ID, AUTHOR_ID;

-- Step 3: Calculate the total profits of each author --

SELECT `AUTHOR ID`, (total_royalty+titles.advance) AS `total_profit`
FROM 

(
SELECT `Title ID`,`AUTHOR ID`,SUM(`sales_royalty`) AS total_royalty 
FROM (
SELECT titles.title_id AS `Title ID`, authors.au_id AS `AUTHOR ID`, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS `sales_royalty`
FROM publications.titles
LEFT JOIN publications.titleauthor ON titleauthor.title_id= titles.title_id
LEFT JOIN publications.authors ON authors.au_id = titleauthor.au_id
LEFT JOIN publications.sales ON titles.title_id=sales.title_id		
) summary
GROUP BY `Title ID`,`AUTHOR ID`
) summary

LEFT JOIN titles ON `Title ID` = titles.title_id
GROUP BY `AUTHOR ID`, `Title ID`,`total_profit`
ORDER BY `total_profit` DESC;


/* Challenge 2 : alternative solution */

-- Table 1 : Calculate the royalties of each sales for each author --

CREATE TEMPORARY TABLE publications.step1

SELECT titles.title_id AS `Title ID`, authors.au_id AS `AUTHOR ID`, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS `sales_royalty`
FROM titles
LEFT JOIN titleauthor ON titleauthor.title_id= titles.title_id
LEFT JOIN publications.authors ON authors.au_id = titleauthor.au_id
LEFT JOIN sales ON titles.title_id=sales.title_id;

-- Table 2 : Aggregate the total royalties for each title for each author --

CREATE TEMPORARY TABLE publications.step2
SELECT `Title ID`, `AUTHOR ID`, SUM(`sales_royalty`) AS total_royalty
FROM publications.step1
GROUP BY `Title ID`, `AUTHOR ID`;

-- Table 3 : Calculate the total profits of each author and select the top 3 --

SELECT `Title ID`,`AUTHOR ID`, (total_royalty+titles.advance) AS `total_profit`
FROM publications.step2
LEFT JOIN publications.titles ON `Title ID` = titles.title_id
GROUP BY `AUTHOR ID`, `Title ID`,`total_profit`
ORDER BY `total_profit` DESC
limit 3;

-- Challenge 3 --

DROP TABLE IF EXISTS `most_profiting_authors`;

create table most_profiting_authors(
	au_id varchar(20),
	profits float
	);

INSERT INTO `most_profiting_authors`(au_id,profits)
SELECT `AUTHOR ID`, (total_royalty + titles.advance) AS `total_profit`
FROM (
	SELECT `Title ID`,`AUTHOR ID`,SUM(`sales_royalty`) AS total_royalty 
	FROM (
		SELECT titles.title_id AS `Title ID`, authors.au_id AS `AUTHOR ID`, (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS `sales_royalty`
		FROM publications.titles
		INNER JOIN publications.titleauthor ON titleauthor.title_id= titles.title_id
		LEFT JOIN publications.authors ON authors.au_id = titleauthor.au_id
		LEFT JOIN publications.sales ON titles.title_id=sales.title_id
	) summary
	GROUP BY `Title ID`,`AUTHOR ID`
	) summary
LEFT JOIN titles ON `Title ID` = titles.title_id
GROUP BY `AUTHOR ID`, `Title ID`,`total_profit`
ORDER BY `total_profit` DESC;