create database ejemplo;
use ejemplo;
create table if not exists t1 ( name string );
show tables;
desc t1;

quit;

create table t2 (codigo integer);

insert into t2 values (10);

use ejemplo;
create table empleados (nombre string, edad integer)
row format delimited
fields terminated by ',';

load data local inpath '/tmp/empleados.txt' into table empleados;
select * from empleados;

drop table empleados;

create external table empleados (nombre string, edad integer)
row format delimited
fields terminated by ','
location '/user/hive/datos/empleados';


CREATE TABLE IF NOT EXISTS empleados_internal (
    name string,
    work_place array<string>,
    sex_age struct<sex:string,age:int>,
    skills_score map<string,int>,
    depart_title map<string,array<string>>
)
comment 'Esto es una tabla interna'
row format delimited
fields terminated by '|'
collection items terminated by ','
map keys terminated by ':';


load data local inpath '/tmp/empleados.txt' overwrite into table empleados_internal;

create external table if not exists empleados_external (
    name string,
    work_place array<string>,
    sex_age struct<sex:string,age:int>,
    skills_score map<string,int>,
    depart_title map<string,array<string>>
)
comment 'This is an external table'
row format delimited
fields terminated by '|'
collection items terminated by ','
map keys terminated by ':'
location '/ejemplo/empleados';

load data local inpath '/tmp/empleados.txt' overwrite into table empleados_external;


create table deslizamientos (id bigint, fecha String, hora String, country String, nearest_places String, hazard_type String, landslide_type String, motivo String, storm_name String, fatalities bigint, injuries String, source_name String, source_link String, location_description String,location_accuracy String, landslide_size String, photos_link String, cat_src String, cat_id bigint, countryname String, near String, distance double, adminnamel String, adminname2 String, population bigint, countrycode String, continentcode String, key String, version String, tstamp String, changeset_id String, latitude double, longitude double, geolocation String) ROW FORMAT DELIMITED FIELDS TERMINATED BY ';';

load data local inpath '/home/hadoop/deslizamientos.csv' into table deslizamientos;

select country, fecha, landslide_type, motivo, fatalities from deslizamientos where fatalities>100;
select motivo, count(*) from deslizamientos group by motivo;

select country, count(*) as total from deslizamientos group by country order by total desc limit 10;

create table paises (nombre string, cod string) row format delimited fields terminated by ',';