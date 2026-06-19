--***********************************************
--008_arreglo_id_sala.sql
--Se corrige el id de las salas (carajo)
--***********************************************

set search_path to cine;

--Vaciamos la tabla para arreglar la kgada
truncate table sala restart identity cascade;

-- Se vuelven a insertar las filas (fokin errores de id)
insert into sala default values;
insert into sala default values;

insert into schema_migrations(version) values('008_arreglo_id_sala.sql');