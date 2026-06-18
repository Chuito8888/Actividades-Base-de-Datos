--******************************
--004_corregir_verificar_hora.sql
--corrección de la función verificar hora
--******************************

set search_path to cine;

create or replace function verificar_hora()
returns trigger as $$
	declare
		v_duracionminutos int;
		v_inicio timestamp;
		v_fin timestamp;
		v_choque text;
begin
	select duracion_minutos into v_duracionminutos
	from pelicula
	where pelicula_id = new.pelicula;
	v_inicio := new.fecha_hora;
	v_fin := new.fecha_hora + (v_duracionminutos || ' minutes')::interval;
	select p.titulo into v_choque
    from funcion f
    join pelicula p on f.pelicula = p.pelicula_id
    where f.sala = new.sala
      and f.funcion_id is distinct from new.funcion_id
      and v_inicio < (f.fecha_hora + (p.duracion_minutos || ' minutes')::interval)
      and v_fin > f.fecha_hora
    limit 1;
    if v_choque is not null then
        raise exception 'conflicto de horario en la sala %. se cruza con la película "%".', 
            new.sala, v_choque;
    end if;
    return new;

end;
$$ language plpgsql;

insert into schema_migrations(version) values('004_corregir_verificar_hora.sql');