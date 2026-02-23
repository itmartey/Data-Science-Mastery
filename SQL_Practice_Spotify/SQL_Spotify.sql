-- ADVANCED PROJECT WITH -- SPOTIFY DATA 

DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    total_views FLOAT, -- "view" was changed to "total_views" as "view" was initially highlighted as a KEYWORD
    likes BIGINT,
    total_comments BIGINT, -- "comments" was changed to "total_comments" as it was highlighted as a KEYWORD
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

-- Exploratory Data Analysis
SELECT COUNT(*) FROM spotify;

SELECT COUNT (DISTINCT album) FROM spotify;

SELECT COUNT (DISTINCT artist) FROM spotify;

SELECT DISTINCT album_type FROM spotify;

SELECT DISTINCT most_played_on FROM spotify;

DELETE FROM spotify 
WHERE duration_min = 0;

/*
-- --------------------------------
-- Data Analysis -- Easy Category 
-- --------------------------------

 Retrieve the names of all tracks that have more than 1 billion streams.
 List all albums along with their respective artists.
 Get the total number of comments for tracks where licensed = TRUE.
 Find all tracks that belong to the album type single.
 Count the total number of tracks by each artist.
*/

-- 1.  Retrieve the names of all tracks that have more than 1 billion streams.

SELECT * FROM spotify 
WHERE stream > 1000000000;

-- 2.  List all albums along with their respective artists.
SELECT DISTINCT album, -- Distinct because one album could have two artists.
		artist
FROM spotify;

-- 3.  Get the total number of comments for tracks where licensed = TRUE.
SELECT SUM(total_comments) as total
		FROM spotify
WHERE licensed = 'true';

-- 4.  Find all tracks that belong to the album type single.
SELECT artist, 
		track, 
		album_type 
FROM spotify 
WHERE album_type = 'single';

-- 5.  Count the total number of tracks by each artist.
SELECT artist,
		COUNT(track) as total_tracks
FROM spotify
GROUP BY artist
ORDER BY total_tracks;

/*
-- --------------------------------
-- Data Analysis -- Medium Level 
-- --------------------------------

Calculate the average danceability of tracks in each album.
Find the top 5 tracks with the highest energy values.
List all tracks along with their views and likes where official_video = TRUE.
For each album, calculate the total views of all associated tracks.
Retrieve the track names that have been streamed on Spotify more than YouTube.

*/

-- 6. Calculate the average danceability of tracks in each album.
SELECT album,
		ROUND(AVG(danceability)::numeric,3) AS avg_danceability -- Rounded to three decimal places for uniformity
FROM spotify
GROUP BY 1
ORDER BY 2 DESC;

-- 7. Find the top 5 tracks with the highest energy values.
SELECT track,
		MAX(energy)
FROM spotify
GROUP BY 1	
ORDER BY MAX(energy) DESC
LIMIT 5;

-- 8. List all tracks along with their views and likes where official_video = TRUE.
SELECT  track,
	   SUM(total_views),
	   SUM(likes)
FROM spotify
WHERE official_video = 'TRUE'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 9. For each album, calculate the total views of all associated tracks.
SELECT album,
		track,
		SUM(total_views)
FROM spotify
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10;
		
-- 10. Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT * FROM 

(SELECT 
		track,
		COALESCE (SUM (CASE WHEN most_played_on = 'Youtube' THEN stream END),0) streamed_on_youtube,
		COALESCE (SUM (CASE WHEN most_played_on = 'Spotify' THEN stream END),0) streamed_on_spotify
FROM spotify
GROUP BY 1
) as t1

WHERE streamed_on_spotify > streamed_on_youtube
 AND  streamed_on_youtube <> 0 ;


/*
-- --------------------------------
-- Data Analysis -- Advanced Level
-- --------------------------------

Find the top 3 most-viewed tracks for each artist using window functions.
Write a query to find tracks where the liveness score is above the average.
Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
Find tracks where the energy-to-liveness ratio is greater than 1.2
Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

*/

-- 11. Find the top 3 most-viewed tracks for each artist using window functions.

WITH ranking_artist
AS
(SELECT 
	artist,
	track,
	SUM(total_views) AS total,
	DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(total_views) DESC) AS ranking
FROM spotify
GROUP BY 1, 2
ORDER BY 1, 3 DESC
)
SELECT * FROM ranking_artist
WHERE ranking <= 3;

-- 12. Write a query to find tracks where the liveness score is above the average.
SELECT 
    track,
    liveness,
    ROUND(liveness::numeric, 3) AS liveness_rounded  -- optional: for nicer display
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify)
ORDER BY liveness DESC; 

-- 13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH cte
AS
(SELECT 
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energery
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest_energy - lowest_energery as energy_diff
FROM cte
ORDER BY 2 DESC;

-- 14. Find tracks where the energy-to-liveness ratio is greater than 1.2

SELECT 
    track,
    artist,                 
    energy,
    liveness,
    ROUND((energy / liveness)::numeric, 3) AS energy_to_liveness_ratio
FROM spotify
WHERE liveness > 0                     --  safety net to prevent division by zero
  AND energy / liveness > 1.2
ORDER BY energy_to_liveness_ratio DESC;                             
