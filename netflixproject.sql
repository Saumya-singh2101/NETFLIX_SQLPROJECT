--NETFLIX

CREATE TABLE NETFLIX(
show_id VARCHAR(10) ,
genre VARCHAR(10),	
title VARCHAR(150),	
director VARCHAR(330),	
members VARCHAR(1000),	
country VARCHAR(200),
date_added VARCHAR(50),	
release_year int ,	
rating VARCHAR(100),	
duration VARCHAR(150),	
listed_in VARCHAR(100),	
description VARCHAR(10000)
);

SELECT * FROM NETFLIX


-- Buisness Problem

--Total number of TV Shows and Movies
SELECT genre,COUNT(*) AS total_count
FROM NETFLIX
GROUP BY genre

--the most watched TV-SHOWS and MOVIES on NETFLIX
SELECT genre, rating, total,
       RANK() OVER (PARTITION BY genre ORDER BY total DESC) AS ranking
FROM (
    SELECT genre, rating, COUNT(*) AS total
    FROM Netflix
    GROUP BY genre, rating
) AS genre_counts
ORDER BY genre, total DESC;


--List of all movies and tv-shows released in 2020 sorted according to the ratings
SELECT title,genre,rating,release_year
FROM Netflix
WHERE release_year>=2020
ORDER BY
CASE 
WHEN genre='Movie' THEN 0
WHEN genre='TV-SHOW' THEN 1
END,
rating DESC;

--Top 5 countries with the most content on NETFLIX
SELECT 
UNNEST(STRING_TO_ARRAY(Country,',')) as New_country,
COUNT(show_id) AS total_content
FROM Netflix
GROUP BY New_country
ORDER BY total_content DESC
LIMIT 5

--The longest movie
SELECT 
  title,
  genre,
  duration AS total_runtime,
  CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) AS minutes
FROM Netflix
WHERE genre = 'Movie' AND duration IS NOT NULL
ORDER BY minutes DESC
LIMIT 1

--Most frequent director in dataset: Rajiv Chilaka (19 titles)
SELECT director,
COUNT (director) AS total_content_produced
FROM Netflix
WHERE director IS NOT NULL
GROUP BY director
ORDER BY total_content_produced desc
LIMIT 1;

--List of Shows with more than 5 seasons along with its rating and realease date
SELECT title, rating, date_added, duration
FROM netflix
WHERE 
  duration LIKE '%Seasons' AND
  CAST(SUBSTRING(duration FROM 1 FOR POSITION(' ' IN duration) - 1) AS INTEGER) > 5
ORDER BY duration DESC

--Average numbers of number of content released in India
SELECT 
  country,
  EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS release_year,
  COUNT(*) AS total_releases
FROM netflix
WHERE country ILIKE '%India%' 
  AND date_added IS NOT NULL
GROUP BY 
  country,
  EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY'))
ORDER BY total_releases DESC
LIMIT 5;

--List of all movies that are documentaries
SELECT * FROM netflix
WHERE listed_in LIKE '%Documentaries'










