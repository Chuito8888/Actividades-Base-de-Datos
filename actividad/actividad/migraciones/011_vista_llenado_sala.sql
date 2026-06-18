--************************************************
--011_vista_llenado_sala.sql
--vista con los datos pedidos por el sensei
--************************************************

set search_path to cine;

create or replace view vista_llenado_sala as
select
	s.sala_id as sala,
	count(distinct a.asiento_id) as capacidad,
	case
		when count(distinct f.funcion_id) = 0 then 0.0
		else round(
		(count(distinct b.boleto_id)*100.0)/
		(count(distinct a.asiento_id)*count(distinct f.funcion_id)),
		2
		)
	end as porcentaje_llenado
	
from sala s
left join asiento a on s.sala_id=a.sala
left join funcion f on s.sala_id=f.sala
left join boleto b on f.funcion_id = b.funcion
group by s.sala_id;

insert into schema_migrations(version) values('011_vista_llenado_sala.sql')