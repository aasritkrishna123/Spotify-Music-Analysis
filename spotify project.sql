select * from spotify;

select count(*) from spotify;

-- EDA
select count(distinct artist) from spotify;

select max(duration_min) from spotify;

select min(duration_min) from spotify;

select * from spotify
where duration_min = 0;

delete from spotify
where duration_min = 0;

select count(*) from spotify;

----------------
Business problems
----------------

-- 1. Retrieve the names of all tracks that have more than 1 billion streams.

select * from spotify
where stream > 100000000;

-- 2. List all albums along with their respective artists.

select album, artist from spotify;

-- 3. Get the total number of comments for tracks where licensed = TRUE.

select sum(comments) as total_comments from spotify
where licensed = 'true';

-- 4. Find all tracks that belong to the album type single.

select * from spotify
where album_type = 'single'

-- 5. Count the total number of tracks by each artist.

select artist, count(track) as total_number_of_tracks 
from spotify
group by artist;

-- 6. Calculate the average danceability of tracks in each album.
select album, avg(danceability) 
from spotify
group by album;

--7. Find the top 5 tracks with the highest energy values.

select track, max(energy) from spotify
group by track
order by 2 desc
limit 5;

-- 8. List all tracks along with their views and likes where official_video = TRUE.

select track, views, likes from spotify
where official_video = 'true'

-- 9. For each album, calculate the total views of all associated tracks.

select album, sum(views) as total_views from spotify
group by album;

-- 10. Retrieve the track names that have been streamed on Spotify more than YouTube.

select * from
(Select track,
    SUM(CASE WHEN most_Played_on = 'youtube' THEN stream END) AS stream_on_youtube,
    SUM(CASE WHEN most_Played_on = 'spotify' THEN stream END) AS stream_on_spotify
  FROM spotify
  GROUP BY track
) AS t1
WHERE stream_on_spotify > stream_on_youtube;

-- 11. Find the top 3 most-viewed tracks for each artist using window functions.

WITH ranking_artist AS (
  SELECT artist, track, 
         SUM(views) AS total_views,
         DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
  FROM spotify
  GROUP BY artist, track
)
SELECT * 
FROM ranking_artist
WHERE rank <= 3
ORDER BY artist, rank;

-- 12. Write a query to find tracks where the liveness score is above the average.

select track, artist, liveness
from spotify
where liveness > (select avg(liveness) from spotify);

-- 13. Use a WITH clause to calculate the difference between the highest and 
-- lowest energy values for tracks in each album.

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
ORDER BY 2 DESC

