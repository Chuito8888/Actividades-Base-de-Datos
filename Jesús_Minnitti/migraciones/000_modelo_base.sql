--***************************************
--000_modelo_base
--Se crean las tablas iniciales cliente, asiento, funcion, boleto, sala, pelicula y el registro de migraciones
--***************************************

create schema if not exists cine;
set search_path to cine;

create table "schema_migrations"(
"version" text primary key,
"updated_at" timestamp default now()
);

CREATE TABLE "cliente" (
  "cliente_id" SERIAL PRIMARY KEY,
  "nombre" TEXT NOT NULL,
  "rut" TEXT NOT NULL,
  "email" TEXT NOT NULL
);

CREATE TABLE "pelicula" (
  "pelicula_id" SERIAL PRIMARY KEY,
  "titulo" TEXT NOT NULL,
  "duracion_minutos" INTEGER
);

CREATE TABLE "sala" (
  "sala_id" SERIAL PRIMARY KEY
);

CREATE TABLE "asiento" (
  "asiento_id" TEXT PRIMARY KEY,
  "sala" INTEGER NOT NULL,
  "estado" TEXT NOT NULL
);

CREATE INDEX "idx_asiento__sala" ON "asiento" ("sala");

ALTER TABLE "asiento" ADD CONSTRAINT "fk_asiento__sala" FOREIGN KEY ("sala") REFERENCES "sala" ("sala_id") ON DELETE CASCADE;

CREATE TABLE "funcion" (
  "funcion_id" SERIAL PRIMARY KEY,
  "pelicula" INTEGER NOT NULL,
  "fecha_hora" TIMESTAMP,
  "sala" INTEGER NOT NULL,
  "precio" INTEGER
);

CREATE INDEX "idx_funcion__pelicula" ON "funcion" ("pelicula");

CREATE INDEX "idx_funcion__sala" ON "funcion" ("sala");

ALTER TABLE "funcion" ADD CONSTRAINT "fk_funcion__pelicula" FOREIGN KEY ("pelicula") REFERENCES "pelicula" ("pelicula_id") ON DELETE CASCADE;

ALTER TABLE "funcion" ADD CONSTRAINT "fk_funcion__sala" FOREIGN KEY ("sala") REFERENCES "sala" ("sala_id") ON DELETE CASCADE;

CREATE TABLE "boleto" (
  "boleto_id" SERIAL PRIMARY KEY,
  "funcion" INTEGER NOT NULL,
  "cliente" INTEGER NOT NULL,
  "asiento" TEXT NOT NULL
);

CREATE INDEX "idx_boleto__asiento" ON "boleto" ("asiento");

CREATE INDEX "idx_boleto__cliente" ON "boleto" ("cliente");

CREATE INDEX "idx_boleto__funcion" ON "boleto" ("funcion");

ALTER TABLE "boleto" ADD CONSTRAINT "fk_boleto__asiento" FOREIGN KEY ("asiento") REFERENCES "asiento" ("asiento_id") ON DELETE CASCADE;

ALTER TABLE "boleto" ADD CONSTRAINT "fk_boleto__cliente" FOREIGN KEY ("cliente") REFERENCES "cliente" ("cliente_id") ON DELETE CASCADE;

ALTER TABLE "boleto" ADD CONSTRAINT "fk_boleto__funcion" FOREIGN KEY ("funcion") REFERENCES "funcion" ("funcion_id") ON DELETE cascade;

insert into schema_migrations(version) values('000_modelo_base.sql');