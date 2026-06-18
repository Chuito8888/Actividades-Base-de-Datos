--******************************************************************
--018_consultas.sql
--consultas pedidas por el master
--******************************************************************

/*
set search_path to cine;

-- 1. Top 3 películas por recaudación total
select 
    p.titulo as pelicula,
    coalesce(sum(case when b.boleto_id is not null then f.precio else 0 end), 0) as recaudacion_total
from pelicula p
left join funcion f on p.pelicula_id = f.pelicula
left join boleto b on f.funcion_id = b.funcion
group by p.pelicula_id, p.titulo
order by recaudacion_total desc
limit 3;
*/

/*
-- 2. Función con el mayor porcentaje de ocupación
select 
    funcion,
    pelicula,
    sala,
    fecha_hora,
    entradas_vendidas,
    (asientos_disponibles + entradas_vendidas) as capacidad_sala,
    round(
        (entradas_vendidas * 100.0) / nullif(asientos_disponibles + entradas_vendidas, 0), 
        2
    ) as porcentaje_ocupacion
from vista_disponibilidad_funcion
order by porcentaje_ocupacion desc
limit 1;
*/

/*
-- 3. Clientes que compraron entradas en 3 o más funciones distintas
select 
    c.nombre,
    c.rut,
    count(distinct b.funcion) as funciones_distintas_visitadas
from cliente c
join boleto b on c.cliente_id = b.cliente
group by c.cliente_id, c.nombre, c.rut
having count(distinct b.funcion) >= 3;
*/

/*
-- 4. Recaudación por sala y por día
select 
    f.sala,
    f.fecha_hora::date as fecha,
    coalesce(sum(case when b.boleto_id is not null then f.precio else 0 end), 0) as recaudacion_dia
from funcion f
left join boleto b on f.funcion_id = b.funcion
group by f.sala, f.fecha_hora::date
order by fecha desc, f.sala asca;
*/

/*
-- 5. Películas que no tienen ninguna entrada vendida
select 
    p.titulo as pelicula_sin_ventas
from pelicula p
left join funcion f on p.pelicula_id = f.pelicula
left join boleto b on f.funcion_id = b.funcion
group by p.pelicula_id, p.titulo
having count(b.boleto_id) = 0;
*/

/*
-- 6. Horario de inicio con más entradas vendidas (La franja peak)
select 
    f.fecha_hora::time as horario_inicio,
    count(b.boleto_id) as total_entradas_vendidas
from funcion f
join boleto b on f.funcion_id = b.funcion
group by f.fecha_hora::time
order by total_entradas_vendidas desc
limit 1;
*/