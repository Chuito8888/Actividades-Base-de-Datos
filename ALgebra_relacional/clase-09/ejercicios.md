## **Script usado para crear las tablas:**
```
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

ALTER TABLE "reserve" ADD CONSTRAINT "fk_reserve__bid" FOREIGN KEY ("bid") REFERENCES "boat" ("bid") ON DELETE CASCADE;

ALTER TABLE "reserve" ADD CONSTRAINT "fk_reserve__sid" FOREIGN KEY ("sid") REFERENCES "sailor" ("sid") ON DELETE CASCADE
```
## **Script para rellenar con datos**
(no me cargó su página así que le pedí a gemini los datos xd)
```
INSERT INTO "boat" ("bid", "bname", "color") VALUES
(101, 'Interlake', 'Blue'),
(102, 'Interlake', 'Red'),
(103, 'Clipper', 'Green'),
(104, 'Marine', 'Red'),
(105, 'BigBoat', 'Blue'),
(106, 'BigBoat', 'Yellow');

INSERT INTO "sailor" ("sid", "sname", "rating", "age") VALUES
(22, 'Dustin', 7.0, 45),
(29, 'Brutus', 1.0, 33),
(31, 'Albert', 8.0, 55),
(32, 'Albert', 9.0, 25),
(58, 'Rusty', 10.0, 35),
(64, 'Horatio', 7.0, 35),
(71, 'Zorba', 10.0, 16),
(74, 'Horatio', 9.0, 35),
(85, 'Bob', 3.0, 22),
(86, 'Bob', 9.5, 19),
(95, 'Bob', 5.0, 63);

INSERT INTO "reserve" ("day", "sid", "bid") VALUES
-- Reservas de Albert (Ejercicio 1)
('2026-05-01', 31, 101), -- Albert reservó un bote Blue
('2026-05-02', 31, 102), -- Albert reservó un bote Red

-- Reservas para el Marinero Dustin (ha reservado al menos dos botes distintos - Ejercicio 3)
('2026-05-03', 22, 101),
('2026-05-04', 22, 102),

-- Reservas para Dustin (ha reservado TODOS los botes llamados 'BigBoat' - Ejercicio 4)
('2026-05-05', 22, 105),
('2026-05-06', 22, 106),

-- Reservas para el Marinero Rusty (ha reservado absolutamente TODOS los botes - Ejercicio 4)
('2026-05-01', 58, 101),
('2026-05-02', 58, 102),
('2026-05-03', 58, 103),
('2026-05-04', 58, 104),
('2026-05-05', 58, 105),
('2026-05-06', 58, 106),

-- Marinero que ha reservado el bote 103 (Ejercicio 1)
('2026-05-07', 29, 103),

-- Marinero con edad > 20 que NO ha reservado bote rojo (Ejercicio 2)
-- El sid 95 (Bob) tiene 63 años y solo reservará botes verdes/azules
('2026-05-08', 95, 103),
('2026-05-09', 95, 101);
```
---
## **Ejercicio 1):**
**Enunciado 1: Encontrar los colores de los botes reservados por el marinero llamado Albert**

**Algebra relacional :**
$$\pi_{color}(\sigma_{sname = 'Albert'}(Boat \bowtie Reserve \bowtie Sailor))$$

**Consulta en sql:**
```
select color from boat b
inner join reserve r on b.bid = r.bid
inner join sailor s on r.sid = s.sid
where s.sname = 'Albert';
```
**Enunciado 2: Encontrar los sid de marineros que tengan rating ≥ 8 o que hayan reservado el bote 103.**

**Algebra relacional :**
$$\pi_{sid}(\sigma_{rating \geq 8}(Sailor)) \cup \pi_{sid}(\sigma_{bid = 103}(Reserve))$$

**Consulta en sql:**
```
select sid as sailor_id from sailor s 
where s.rating >= 8
union
select r.sid from reserve r where r.bid = 103
```
## **Ejercicio 2):**

**Enunciado 1: Encontrar los nombres de marineros que no han reservado un bote rojo**

**Algebra relacional:**
$$\pi_{sname}(Sailor) - \pi_{sname}(Sailor \bowtie Reserve \bowtie \sigma_{color = 'Red'}(Boat))$$

**Consulta en SQL:**
```
select s.sname from sailor s
except
select s.sname from sailor s
inner join reserve r on s.sid= r.sid 
inner join boat b on r.bid=b.bid 
where b.color = 'Red';
```
**Enunciado 2: Encontrar los sid de marineros con edad mayor a 20 que no han reservado un bote rojo**

**Algebra relacional**
$$\pi_{ssid}(\sigma_{sage>20}(sailor) - \pi_{ssid}(sailor \bowtie Reserve \bowtie \sigma_{color='Red'}(Boat))$$

**Consulta en SQL:**
```
select s.sid from sailor s where s.age > 20
except
select s.sid from sailor s
inner join reserve r on s.sid= r.sid 
inner join boat b on r.bid= b.bid
where b.color = 'Red'
```

## **Ejercicio 3):**

**Enunciado 1: Encontrar los nombres de marineros que han reservado al menos dos botes distintos.**

**Algebra relacional:**
$$\pi_{sname}( \sigma_{r1.sid=r2.sid ∧ r1.bid≠r2.bid}( \rho_{r1}(Reserves) × \rho_{r2}(Reserves) ) \bowtie Sailors )

**Consulta en SQL:** 
```
select distinct s.sname from sailor s
join reserve r1 on s.sid = r1.sid
join reserve r2 on s.sid = r2.sid and r2.bid <> r1.bid;
```

**Enunciado 2:  Encontrar los sid de marineros cuyo rating es mejor que el de
   algún marinero llamado Bob.**

**Algebra relacional:**
$$\pi_{s1.sid}(\sigma_{s1.rating>s2.sname ^ s2.sname= 'Bob'}(\rho_{s1}(Sailor) x \rho_{s2}(Sailor))

**Consulta en SQL:** 
```
select distinct s1.sid from sailor s1
cross join  sailor s2
where s1.rating > s2.rating and s2.sname = 'Bob';
```
   

