--********************************
--010_validar_disponibilidad_asiento.sql
--Funcion y trigger para validar la disponibilidad de los asientos
--se verifica que el asiento que se quiere comprar no esté ya ocupado
--esto evita también la sobreventa ya que el boleto depende de un asiento existente
--por lo que se asegura que un asiento no se compre 2 veces en la misma funcion
--a la par que por lógica no se puede exceder la capacidad de la sala
--mucho texto d:
--********************************

set search_path to cine;

create or replace function validar_disponibilidad_asiento()
returns trigger as $$
declare
    v_sala_funcion int;
    v_sala_asiento int;
begin
    select sala into v_sala_funcion
    from funcion
    where funcion_id = new.funcion;

    select sala into v_sala_asiento
    from asiento
    where asiento_id = new.asiento;

    if v_sala_funcion != v_sala_asiento then
        raise exception 'el asiento "%" no pertenece a la sala de esta función (sala %).', 
            new.asiento, v_sala_funcion;
    end if;

    --Aquí se valida que el asiento no esté ocupado
    if exists (
        select 1 
        from boleto 
        where funcion = new.funcion 
          and asiento = new.asiento
    ) then
        raise exception 'el asiento "%" ya está ocupado para esta función.', new.asiento;
    end if;

    return new;
end;
$$ language plpgsql;

create trigger trigger_validar_disponibilidad_asiento
before insert on boleto
for each row
execute function validar_disponibilidad_asiento();

insert into schema_migrations(version) values('010_validar_disponibilidad_asiento.sql');