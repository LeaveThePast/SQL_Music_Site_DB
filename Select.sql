-- Название и год выхода альбомов, вышедших в 2018 году.
select
	"name" ,
	release_date
from
	album
where
	date_part('year', release_date) = 2018;

-- Название и продолжительность самого длительного трека.
select
	"name" ,
	duration
from
	track
where
	duration = (
	select
		MAX(duration)
	from
		track);
	
-- Название треков, продолжительность которых не менее 3,5 минут.
select
	"name" ,
	duration
from
	track
where
	duration >= 210;

-- Названия сборников, вышедших в период с 2018 по 2020 год включительно.
select
	"name"
from
	collection
where
	date_part('year', release_date) >= 2018
	and date_part('year', release_date) <= 2020;

-- Исполнители, чьё имя состоит из одного слова.
select
	"name"
from
	performer
where
	(LENGTH("name")-LENGTH(replace("name" , ' ', ''))+ 1)= 1;

-- Название треков, которые содержат слово «мой» или «my».
select
	"name"
from
	track
where
	"name" like '%My%';

-- Количество исполнителей в каждом жанре.
select
	g."name" ,
	count(performer_id)
from
	genre_performer gp
join
	genre g on
	genre_id = g.id
group by
	g."name" 
order by
	count(performer_id) desc

-- Количество треков, вошедших в альбомы 2019–2020 годов.
select
	count(t."name")
from
	track t
join album a on
	t.album_id = a.id
where
	date_part('year', release_date) >= 2018
	and date_part('year', release_date) <= 2020
group by
	album_id;

-- Средняя продолжительность треков по каждому альбому.
select
	album_id,
	avg(duration)
from
	track t
group by
	album_id
order by
	avg(duration) desc;

-- Все исполнители, которые не выпустили альбомы в 2020 году.
select
	p."name"
from
	performer p
where
	"name" not in (
	select
		p2."name"
	from
		performer p2
	join album_performer ap2 on
		id = ap2.performer_id
	join album a2 on
		ap2.album_id = a2.id
	where
		date_part('year', release_date) = 2020);


-- Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами)
select
	c."name"
from
	collection c
join collection_track ct on
	c.id = ct.collection_id
join track t on
	ct.track_id = t.id
join album a on
	t.album_id = a.id
join album_performer ap on
	a.id = ap.album_id
join performer p on
	ap.performer_id = p.id
where
	p."name" = 'Name';

-- Названия альбомов, в которых присутствуют исполнители более чем одного жанра.
select
	a."name",
	p.id 
from
	album a
join album_performer ap on
	a.id = ap.album_id
join performer p on
	ap.performer_id = p.id
join genre_performer gp on
	p.id = gp.performer_id
group by
	a."name",
	p.id 
having
	count(gp.genre_id) > 1;
	
-- Наименования треков, которые не входят в сборники.
select
	name
from
	track t
join collection_track ct on
	ct.track_id = t.id 
where
	ct.track_id = null;
	
-- Исполнитель или исполнители, написавшие самый короткий по продолжительности трек, — теоретически таких треков может быть несколько
select
	p."name"
from
	performer p
join album_performer ap on
	p.id = ap.performer_id
join album a on
	ap.album_id = a.id
join track t on
	a.id = t.album_id
where
	duration = (
	select
		Min(duration)
	from
		track);
	
-- Названия альбомов, содержащих наименьшее количество треков.
select
	a."name"
from
	album a
join track t on
	a.id = t.album_id
group by
	a."name"
having
	COUNT(t.id) = (
	select
		count(t2.id)
	from
		track t2
	join album a2 on
		t2.album_id = a2.id
	group by
		a2."name"
	order by
		COUNT(t2.id)
		limit 1
)
