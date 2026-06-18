--*********************************************
--012_vista_ventas_funcion.sql
--Vista con los datos pedidos por el estimado maestro
--*********************************************

set search_path to cine;

create or replace view vista_ventas_funcion as
select
	f.funcion_id as funcion, p.titulo as pelicula, f.sala as sala, f.fecha_hora,
	coalesce(sum(f.precio),0) as monto_total,
	
	case
		when sum(coalesce(sum(f.precio),0)) over(partition by f.fecha_hora::date) = 0 then 0.0
		else round(
		(coalesce(sum(f.precio),0)*100.00)/
		sum(coalesce(sum(f.precio), 0)) over (partition by f.fecha_hora::date),
		2)
	end as porcentaje_del_dia
	
	from funcion f
	join pelicula p on f.pelicula = p.pelicula_id
	left join boleto b on f.funcion_id = b.funcion
	group by f.funcion_id,p.titulo,f.sala,f.fecha_hora;
	
	insert into schema_migrations(version) values('012_vista_ventas_funcion.sql');
	