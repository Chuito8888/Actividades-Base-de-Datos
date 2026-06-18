--****************************
--001_peliculas.sql
--Se insertan varias peliculas de prueba en la tabla
--***************************

set search_path to cine;

insert into pelicula(titulo,duracion_minutos)
values ('Tarzan', 120),('Spider Man',100),('KPOP Demon Hunters',90),('Triana la destripadora',120),('Transformers 3',120),('Avengers: Endgame', 180);

insert into schema_migrations(version) values('001_peliculas.sql');