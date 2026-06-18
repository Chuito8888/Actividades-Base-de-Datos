--*********************************************
--017_correcion_recaudacion.sql
--Vista corregida: muestra $0 en funciones sin boletos vendidos
--Menos mal me dí cuenta
--*********************************************

set search_path to cine;

create or replace view vista_ventas_funcion as
select
    f.funcion_id as funcion, 
    p.titulo as pelicula, 
    f.sala as sala, 
    f.fecha_hora,
    
    coalesce(sum(case when b.boleto_id is not null then f.precio else 0 end), 0) as monto_total,
    
    case
        when sum(coalesce(sum(case when b.boleto_id is not null then f.precio else 0 end), 0)) over(partition by f.fecha_hora::date) = 0 then 0.0
        else round(
            (coalesce(sum(case when b.boleto_id is not null then f.precio else 0 end), 0) * 100.0) /
            sum(coalesce(sum(case when b.boleto_id is not null then f.precio else 0 end), 0)) over(partition by f.fecha_hora::date), 
            2
        )
    end as porcentaje_del_dia
    
from funcion f
join pelicula p on f.pelicula = p.pelicula_id
left join boleto b on f.funcion_id = b.funcion
group by f.funcion_id, p.titulo, f.sala, f.fecha_hora;

insert into schema_migrations(version) values('017_correcion_recaudacion.sql');