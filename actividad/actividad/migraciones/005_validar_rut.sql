--********************************
--005_validar_rut.sql
--se implementa la función y trigger para validar el rut de un cliente (algoritmo módulo 11)
--Me di cuenta q me olvide de poner el set search_path en las primeras migraciones (emoji de la flor)
--********************************

set search_path to cine;

create or replace function validar_rut()
returns trigger as $$
declare
    v_rut_limpio text;
    v_cuerpo text;
    v_dv_ingresado text;
    v_factor int := 2;
    v_suma int := 0;
    v_i int;
    v_resto int;
    v_dv_esperado text;
begin
    v_rut_limpio := upper(regexp_replace(new.rut, '[^0-9kK]', '', 'g'));

    if length(v_rut_limpio) < 2 then
        raise exception 'el rut "%" no tiene un largo válido', new.rut;
    end if;

    v_cuerpo := substr(v_rut_limpio, 1, length(v_rut_limpio) - 1);
    v_dv_ingresado := substr(v_rut_limpio, length(v_rut_limpio), 1);

    if v_cuerpo !~ '^[0-9]+$' then
        raise exception 'el rut "%" contiene caracteres inválidos en el cuerpo', new.rut;
    end if;

    for v_i in reverse length(v_cuerpo)..1 loop
        v_suma := v_suma + (cast(substr(v_cuerpo, v_i, 1) as int) * v_factor);
        v_factor := v_factor + 1;
        if v_factor > 7 then
            v_factor := 2;
        end if;
    end loop;

    v_resto := 11 - (v_suma % 11);

    if v_resto = 11 then
        v_dv_esperado := '0';
    elsif v_resto = 10 then
        v_dv_esperado := 'K';
    else
        v_dv_esperado := cast(v_resto as text);
    end if;

    if v_dv_ingresado != v_dv_esperado then
        raise exception 'el rut "%" no es válido (dígito verificador incorrecto)', new.rut;
    end if;

    --se guarda el rut formateado limpiamente (ej: 12345678-K) en la base de datos
    new.rut := v_cuerpo || '-' || v_dv_ingresado;

    return new;
end;
$$ language plpgsql;

-- se crea el trigger para verificar el rut antes de insertar o actualizar en cliente
create trigger trigger_validar_rut
before insert or update on cliente
for each row
execute function validar_rut();

insert into schema_migrations(version) values('005_validar_rut.sql');