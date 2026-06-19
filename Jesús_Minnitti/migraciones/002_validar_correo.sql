--********************************
--002_validar_correo.sql
--Se implemente la funcion y trigger que valida el correo al crear un usuario
--********************************

set search_path to cine;

--Funcion para validar
create or replace function validar_correo()
returns trigger as $$
begin
--Usando una expresión regular verificamos que el correo esté en un formato valido
	if lower(new.email) !~ '^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$' then
		raise exception 'El correo ingresado "%" no es valido',new.email;
	end if;
	return new;
end;
$$ language plpgsql;

--Se crea el trigger para verificar el correo antes de insertar o actualizar una fila en cliente
create trigger trigger_validar_email
before insert or update on "cliente"
for each row
execute function validar_correo();

insert into schema_migrations(version) values('002_validar_correo.sql');