#Script usado para crear las tablas:

CREATE TABLE "boat" (
  "bid" SERIAL PRIMARY KEY,
  "bname" TEXT NOT NULL,
  "color" TEXT NOT NULL
);

CREATE TABLE "sailor" (
  "sid" SERIAL PRIMARY KEY,
  "sname" TEXT NOT NULL,
  "rating" DECIMAL(12, 2),
  "age" INTEGER
);

CREATE TABLE "reserve" (
  "id" SERIAL PRIMARY KEY,
  "day" DATE,
  "sid" INTEGER NOT NULL,
  "bid" INTEGER NOT NULL
);

CREATE INDEX "idx_reserve__bid" ON "reserve" ("bid");

CREATE INDEX "idx_reserve__sid" ON "reserve" ("sid");

1) Consulta en sql:

select color from boat b
inner join reserve r on b.bid = r.bid
inner join sailor s on r.sid = s.sid
where s.sname = 'Albert';

ALTER TABLE "reserve" ADD CONSTRAINT "fk_reserve__bid" FOREIGN KEY ("bid") REFERENCES "boat" ("bid") ON DELETE CASCADE;

ALTER TABLE "reserve" ADD CONSTRAINT "fk_reserve__sid" FOREIGN KEY ("sid") REFERENCES "sailor" ("sid") ON DELETE CASCADE
