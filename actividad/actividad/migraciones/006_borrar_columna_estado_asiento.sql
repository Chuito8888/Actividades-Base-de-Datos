--*************************************
--006_borrar_columna_estado_asiento.sql
--Borra la columna estado de asiento we
--*************************************

set search_path to cine;

alter table "asiento" drop column estado;

insert into schema_migrations(version) values('006_borrar_columna_estado_asiento.sql');