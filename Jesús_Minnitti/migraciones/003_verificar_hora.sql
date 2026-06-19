--******************************
--003_verificar_hora.sql
--Se implementa una verificacion para asegurarse que las funciones no choquen en sus horarios
--Ademas de su respectivo trigger
--Ahora si me acordé de poner la migración
--******************************
set search_path to cine;

CREATE OR REPLACE FUNCTION verificar_hora()
RETURNS TRIGGER AS $$
	declare
		v_duracionminutos int;
		v_inicio timestamp;
		v_fin timestamp;
		v_choque text;
begin
	select "duracion_pelicula" into v_duracionminutos
	from "pelicula"
	where "pelicula_id" = new."pelicula";

	v_inicio:= new."fecha_hora";
	v_fin:= new."fecha_hora"+(v_duracionminutos|| 'minutes')::interval;
	select p."titulo" INTO v_choque
    FROM "funcion" f
    JOIN "pelicula" p ON f."pelicula" = p."pelicula_id"
    WHERE f."sala" = NEW."sala"
      AND f."funcion_id" IS DISTINCT FROM NEW."funcion_id"
      AND v_inicio < (f."fecha_hora" + (p."duracion_minutos" || ' minutes')::INTERVAL)
      AND v_fin > f."fecha_hora"
    LIMIT 1;

    IF v_choque IS NOT NULL THEN
        RAISE EXCEPTION 'Conflicto de horario en la Sala %. Se cruza con la película "%".', 
            NEW."sala", v_choque;
    END IF;
    RETURN NEW;

end;
$$ LANGUAGE plpgsql;

create trigger trigger_verificar_hora
before insert or update on "funcion"
for each row
execute function verificar_hora();

insert into schema_migrations(version) values('003_verificar_hora.sql');