-- Cómo se llaman los músicos de las bandas que cantan Hip hop y que han vendido más de mil discos 
use bandas;

select *
	from Band_musicians bm
	right join Musician_name mn on bm.musician_id=mn.musician_id
	left join Band b on bm.band_id=b.band_id
	right join Band_genre bg on b.band_id=bg.band_id
	left join Album a on a.band_id=b.band_id;

-- EXPLAIN ANALYZE
SET SQL_SAFE_UPDATES = 0;
EXPLAIN ANALYZE
update musician_name
set musician_name = CONCAT(musician_name, '1000')
where musician_name in (with complex as (select mn.musician_id AS musician_id_mn,
    bm.musician_id AS musician_id_bm,
    mn.musician_name,
    b.band_name,
    bg.genre_name,
    a.album_name,
    a.sales_amount
    
	from Band_musicians bm
	right join Musician_name mn on bm.musician_id=mn.musician_id
	left join Band b on bm.band_id=b.band_id
	right join Band_genre bg on b.band_id=bg.band_id
	left join Album a on a.band_id=b.band_id)
    
select  distinct musician_name
from complex 
where genre_name like "%ip%" and genre_name like "%op%" and sales_amount>1000);

# EXPLAIN
--  Update musician_name (immediate)  (actual time=37.7..37.7 rows=0 loops=1)
    
CREATE INDEX idx_genre_name 
ON genre_name (Band_genre);

CREATE INDEX idx_sales_amount 
ON sales_amount(Album);

# EXPLAIN
-- Update musician_name (immediate)  (actual time=36.2..36.2 rows=0 loops=1)

CREATE INDEX idx_musician_name 
ON musician_name(Musician_name);

# EXPLAIN
-- Update musician_name (buffered)  (actual time=23.4..23.4 rows=0 loops=1)
    



select mn.musician_id AS musician_id_mn,
    bm.musician_id AS musician_id_bm,
    mn.musician_name,
    b.band_name,
    bg.genre_name,
    a.album_name,
    a.sales_amount
	from Band_musicians bm
	right join Musician_name mn on bm.musician_id=mn.musician_id
	left join Band b on bm.band_id=b.band_id
	right join Band_genre bg on b.band_id=bg.band_id
	left join Album a on a.band_id=b.band_id
    where genre_name like "%ip%" and genre_name like "%op%" and sales_amount>1000;

DELIMITER $$

CREATE PROCEDURE names_update()
BEGIN
    update Musician_name
	set musician_name = CONCAT(musician_name, 'qwe')
	where musician_name in (select * from(
    select  distinct musician_name
	from Band_musicians bm
	right join Musician_name mn on bm.musician_id=mn.musician_id
	left join Band b on bm.band_id=b.band_id
	right join Band_genre bg on b.band_id=bg.band_id
	left join Album a on a.band_id=b.band_id
	where genre_name like "%ip%" and genre_name like "%op%" and sales_amount>1000) as temp_names);
END $$

DELIMITER ;

CALL names_update();


CREATE VIEW vista