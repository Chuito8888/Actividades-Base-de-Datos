--**********************************+
--007_salas.sql
--Se insertan salas
--**********************************

set search_path to cine;

insert into sala default values;
insert into sala default values;

insert into schema_migrations(version) values('007_salas.sql');