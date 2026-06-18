--***********************************
--014_relleno_datos.sql
--Le metemos datos pa rellenar asi como naruto
--OJO solo para cliente y funciones, los boletos pa lo ultimo
--***********************************

set search_path to cine;

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


insert into funcion(pelicula,fecha_hora,sala, precio) values 
    (1, '2026-06-18 13:00:00',1, 4500),
    (2, '2026-06-18 15:30:00',1, 5000),
    (1, '2026-06-18 18:00:00',1, 4500), 
    (2, '2026-06-18 20:30:00',1, 5500),
    (3, '2026-06-18 14:00:00',2, 4000),
    (6, '2026-06-18 16:30:00',2, 6000),
    (5, '2026-06-18 20:00:00',2, 4500);

insert into schema_migrations(version) values('014_relleno_datos_1.sql');