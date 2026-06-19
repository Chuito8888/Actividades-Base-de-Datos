--********************************
--016_ventas_boletos_prueba.sql
--compra masiva de entradas (taban a luka en la pagina)
--Probé a llenar una sala para revisar las vistas
--********************************

set search_path to cine;

insert into boleto (funcion, cliente, asiento) values 
	(1,1,'s1-a1'),
	(1,2,'s1-a2'),
	(1,3,'s1-a3'),
	(1,4,'s1-a4'),
	(1,5,'s1-a5'),
	(1,6,'s1-b1'),
	(1,7,'s1-b2'),
	(1,8,'s1-b3'),
	(1,9,'s1-b4'),
	(1,10,'s1-b5'),
	
    (5, 1, 's2-a4'),
    (5, 2, 's2-a5'); 

insert into schema_migrations(version) values('016_ventas_boletos_prueba.sql');