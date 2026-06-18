--***********************************
--015_correcion.sql
--Otra vez los ids carajo
--***********************************

set search_path to cine;

--Sybau
truncate table cliente cascade;
alter sequence cliente_cliente_id_seq restart with 1;

insert into cliente(nombre,rut,email) values
('Jesús','273838392','jesus.minnitti@gmail.com'),('Paz','220972313','paz.oyarzun@gmail.com'),
('Esteban quito', '20.317.382-2', 'esteban.quito@gmail.com'),
('María', '18690043-k', 'mariajose@outlook.cl'),
('Juan', '214834367', 'jp.duarte@ing.uach.cl'),
('Gonzalo', '14016678-2', 'gonza.tapia93@hotmail.com'),
('Johannes', '22.206.978-5', 'chancho.kl@gmail.com'),
('Lucas', '208144685', 'loco.rene@gmail.com'),
('Camila', '84.775.487', 'camilla.flores@yahoo.com'),
('Ricardo', '228560170', 'rmilos@vtr.net'),
('Sofia', '5610869-6', 'sofisticada.67@uc.cl'),
('DieGOD', '20.422.755-1', 'diego.sql.profe@gmail.com');

insert into schema_migrations(version) values('015_correcion.sql');