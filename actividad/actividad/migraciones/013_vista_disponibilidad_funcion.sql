--*****************************************
--013_vista_disponibilidad_funcion
--vista que muestra la informacion solicitada por el rey
--*****************************************

set search_path to cine;

create or replace view vista_disponibilidad_funcion as
select 
    f.funcion_id as funcion,
    p.titulo as pelicula,
    f.sala,
    f.fecha_hora,
    
    sum(case when b.boleto_id is null then 1 else 0 end) as asientos_disponibles,
    
    coalesce(string_agg(case when b.boleto_id is null then a.asiento_id end, ', '), 'ninguno') as lista_asientos_disponibles,
    
    count(b.boleto_id) as entradas_vendidas,
    
    coalesce(sum(case when b.boleto_id is not null then f.precio else 0 end), 0) as recaudado

from funcion f
join pelicula p on f.pelicula = p.pelicula_id
join asiento a on f.sala = a.sala
left join boleto b on f.funcion_id = b.funcion and a.asiento_id = b.asiento
group by f.funcion_id, p.titulo, f.sala, f.fecha_hora;

insert into schema_migrations(version) values('013_vista_disponibilidad_funcion.sql');
	
	