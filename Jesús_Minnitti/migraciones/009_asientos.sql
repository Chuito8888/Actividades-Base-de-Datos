--*****************************************************
--009_asientos.sql
--Se insertan asientos ahora que ya existen las 2 salas
--*****************************************************

set search_path to cine;

insert into asiento (asiento_id, sala) values 
('s1-a1', 1), ('s1-a2', 1), ('s1-a3', 1), ('s1-a4', 1), ('s1-a5', 1),
('s1-b1', 1), ('s1-b2', 1), ('s1-b3', 1), ('s1-b4', 1), ('s1-b5', 1),
('s2-a1', 2), ('s2-a2', 2), ('s2-a3', 2), ('s2-a4', 2), ('s2-a5', 2),
('s2-b1', 2), ('s2-b2', 2), ('s2-b3', 2), ('s2-b4', 2), ('s2-b5', 2);

insert into schema_migrations(version) values('009_asientos.sql');