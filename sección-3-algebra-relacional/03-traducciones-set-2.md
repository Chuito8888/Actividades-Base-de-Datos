## **Sección 1) SQL -> Algebra Relacional**

**1) Colores de los botes reservados por Albert.**
```
select distinct b.color from sailors s
join reserves r on r.sid = s.sid
join boats b on b.bid = r.bid
where s.sname = 'Albert';
```

**Algebra Relacional:**
$$\pi_{color}(\sigma_{sname = 'Albert'}(sailors) \bowtie reserves \bowtie boats)$$

**2) sid de marineros con rating >= 8 o que reservaron el bote 103.**
```
select sid from sailors where rating >=8
union
select sid from reserves where bid = 103;
```

**Algebra Relacional:**
$$\pi_{sid}(\sigma_{rating \ge 8}(sailors)) \cup \pi_{sid}(\sigma_{bid = 103}(reserves))$$

**3) Nombres de marineros que no reservaron un bote rojo.**
```
select s.sname from sailors s
where s.sid not in(
  select r.sid from reserves r join boats b on b.bid = r.bid
  where b.color = 'red'
);
```

**Algebra Relacional:**
$$\pi_{sname}(sailors \bowtie (\pi_{sid}(sailors) - \pi_{sid}(reserves \bowtie \sigma_{color = 'red'}(boats))))$$

**4) sid de marineros con edad > 20 que no reservaron un bote rojo.**
```
select s.sid from sailors s where s.age > 20
and s.sid not in(
  select r.sid from reserves r join boats b on b.bid = r.bid
  where b.color = 'red'
);
```

**Algebra Relacional:**
$$\pi_{sid}(\sigma_{age > 20}(sailors)) - \pi_{sid}(reserves \bowtie \sigma_{color = 'red'}(boats))$$

**5) Nombres de marineros que reservaron al menos dos botes distintos.**
```
select distinct s.sname from sailors s
join reserves r1 on r1.sid = s.sid
join reserves r2 on r2.sid = s.sid
where r1.bid <> r2.bid;
```

**Algebra Relacional:**
$$\pi_{sname}(sailors \bowtie \pi_{sid}(\sigma_{r1.bid \neq r2.bid}(\rho_{r1}(reserves) \bowtie_{r1.sid = r2.sid} \rho_{r2}(reserves))))$$

**6) Nombres de marineros que reservaron todos los botes.**
```
select s.sname from sailors s where not exists(
  select 1 from boats b where not exists(
    select 1 from reserves r where r.sid = s.sid and r.bid = b.bid
));
```

**Algebra Relacional:**
$$\pi_{sname}(sailors \bowtie (\pi_{sid, bid}(reserves) \div \pi_{bid}(boats)))$$

**7) Nombres de marineros que reservaron todos los botes llamados 'BigBoat'.**
```
select s.sname from sailors s where not exists(
  select 1 from boats b where b.bname = 'BigBoat' and not exists(
    select 1 from reserves r where r.sid = s.sid and r.bid = b.bid
));
```

**Algebra Relacional:**
$$\pi_{sname}(sailors \bowtie (\pi_{sid, bid}(reserves) \div \pi_{bid}(\sigma_{bname = 'BigBoat'}(boats))))$$

**8) Nombres de proveedores que suministran alguna parte roja.**
```
select distinct s.sname from suppliers s
join catalog c on c.sid = s.sid
join parts p on p.pid = c.pid
where p.color = 'red';
```

**Algebra Relacional:**
$$\pi_{sname}(suppliers \bowtie catalog \bowtie \sigma_{color = 'red'}(parts))$$

**9) sid de proveedores que suministran alguna parte roja o verde.**
```
select distinct c.sid from catalog c
join parts p on p.pid = c.pid
where p.color in ('red','green');
```

**Algebra Relacional:**
$$\pi_{sid}(catalog \bowtie \sigma_{color = 'red' \vee color = 'green'}(parts))$$

**10) sid de proveedores que suministran una parte roja o están en 21 George Street.**
```
select c.sid from catalog c join parts p on p.pid= c.pid where p.color = 'red'
union
select sid from suppliers where address = '21 George Street';
```

**Algebra Relacional:**
$$\pi_{sid}(catalog \bowtie \sigma_{color = 'red'}(parts)) \cup \pi_{sid}(\sigma_{address = '21 George Street'}(suppliers))$$

**11) sid de proveedores que suministran alguna parte roja y alguna verde.**
```
select sid from catalog c join parts p on p.pid = c.pid where p.color = 'red'
intersect
select sid from catalog c join parts p on p.pid = c.pid where p.color = 'green';
```

**Algebra Relacional:**
$$\pi_{sid}(catalog \bowtie \sigma_{color = 'red'}(parts)) \cap \pi_{sid}(catalog \bowtie \sigma_{color = 'green'}(parts))$$

**12) Pares de sid tales que el primero cobra más que el segundo por la misma parte.**
```
select c1.sid as sid_caro, c2.sid as sid_barato from catalog c1
join catalog c2 on c1.pid = c2.pid and c1.cost > c2.cost;
```

**Algebra Relacional:**
$$\pi_{c1.sid, c2.sid}(\sigma_{c1.cost > c2.cost}(\rho_{c1}(catalog) \bowtie_{c1.pid = c2.pid} \rho_{c2}(catalog)))$$

**13) sid de proveedores que suministran solo partes rojas.**
```
select sid from suppliers
except
select c.sid from catalog c join parts p on p.pid=c.pid where p.color <> 'red';
```

**Algebra Relacional:**
$$\pi_{sid}(suppliers) - \pi_{sid}(catalog \bowtie \sigma_{color \neq 'red'}(parts))$$

**14) sid de proveedores que suministran todas las partes.**
```
select c.sid from catalog c
group by c.sid having count(distinct c.pid) = (select count(*) from parts);
```

**Algebra Relacional:**
$$\pi_{sid, pid}(catalog) \div \pi_{pid}(parts)$$

**15) Nombres y salarios de jefes que tienen algun empleado con salario > 100.**
```
select distinct b.name, b.salary from eployees b
join supervises sv on sv.boss = b.number
join employees e on e.number = sv.employee
where e.salary > 100;
```

**Algebra Relacional:**
$$\pi_{b.name, b.salary}(\rho_{b}(employees) \bowtie_{b.number = sv.boss} supervises \bowtie_{sv.employee = e.number} \sigma_{salary > 100}(\rho_{e}(employees)))$$

**16) Pares (jefe,empleado) donde el empleado gana más que su jefe.**
```
select b.name as jefe, e.name as empleado from supervises sv
join employees b on b.number = sv.boss
join employees e on e.number = sv.eployee
where e.salary > b.salary;
```

**Algebra Relacional:**
$$\pi_{b.name, e.name}(\sigma_{e.salary > b.salary}(\rho_{b}(employees) \bowtie_{b.number = sv.boss} supervises \bowtie_{sv.employee = e.number} \rho_{e}(employees)))$$

**17) Nombres de empleados que no tienen jefe.**
```
select name from employees
where number not in (select employee from supervises);
```

**Algebra Relacional:**
$$\pi_{name}(employees \bowtie (\pi_{number}(employees) - \pi_{employee}(supervises)))$$

**18) Hora de cita y nombre del cliente para las citas de Giuliano el 2026-02-14.**
```
select c.name, a.atime from appointments a
join staff s on s.sid = a.sid
join clients c on c.cid = a.cid
where a.adate = date '2026-02-14' and s.name = 'Giuliano';
```

**Algebra Relacional:**
$$\pi_{clients.name, atime}(\sigma_{adate = '2026\text{-}02\text{-}14'}(appointments) \bowtie clients \bowtie \sigma_{name = 'Giuliano'}(staff))$$

**19) Servicios que han sido solicitados al menos una vez.**
```
select distinct service from appointments;
```

**Algebra Relacional:**
$$\pi_{service}(appointments)$$

**20) Clientes (nombre y teléfono) que nunca tomaron el servicio manicure.**
```
select c.name, c.phone from clients c
where c.cid not in(select cid from appointments where service = 'manicure');
```

**Algebra Relacional:**
$$\pi_{name, phone}(clients \bowtie (\pi_{cid}(clients) - \pi_{cid}(\sigma_{service = 'manicure'}(appointments))))$$


## **Sección 2: Algebra Relacional -> SQL**

**1)**
$$\pi_{sid}\bigl(\sigma_{rating > 7}(sailors)\bigr)$$
**Consulta SQL:**
```
select sid 
from sailors 
where rating > 7;
```

**2)**
$$\pi_{sname}\bigl(\sigma_{age \geq 18 \wedge age \leq 25}(sailors)\bigr)$$

**Consulta SQL:**
```
select sname 
from sailors 
where age >= 18 and age <= 25;
```

**3)**
$$\pi_{sname}\bigl(sailors \bowtie reserves \bowtie \sigma_{color='red'}(boats)\bigr)$$

**Consulta SQL:**
```
select distinct s.sname 
from sailors s
join reserves r on s.sid = r.sid
join boats b on r.bid = b.bid
where b.color = 'red';
```

**4)**
$$\pi_{s1.sid}\bigl(\rho_{s1}(sailors) \bowtie_{s1.rating > s2.rating} \rho_{s2}(\sigma_{sname='Bob'}(sailors))\bigr)$$

**Consulta SQL:**
```
select distinct s1.sid 
from sailors s1
join sailors s2 on s1.rating > s2.rating
where s2.sname = 'Bob';
```

**5)**
$$\pi_{sid}(sailors);-;\pi_{s1.sid}\bigl(\rho_{s1}(sailors) \bowtie_{s1.rating < s2.rating} \rho_{s2}(sailors)\bigr)$$

**Consulta SQL:**
```
select sid from sailors
except
select s1.sid 
from sailors s1
join sailors s2 on s1.rating < s2.rating;
```

**6)**
$$\pi_{pname}\bigl(\sigma_{color='red'}(parts)\bigr)$$

**Consulta SQL:**
```
select pname 
from parts 
where color = 'red';
```

**7)**
$$\pi_{cost}\bigl(\sigma_{color='red' \vee color='green'}(parts) \bowtie catalog\bigr)$$

**Consulta SQL:**
```
select c.cost 
from parts p
join catalog c on p.pid = c.pid
where p.color = 'red' or p.color = 'green';
```

**8)**
$$\pi_{sid}\bigl(\sigma_{color='red' \vee color='green'}(parts) \bowtie catalog\bigr)$$

**Consulta SQL:**
```
select distinct c.sid 
from parts p
join catalog c on p.pid = c.pid
where p.color = 'red' or p.color = 'green';
```

**9)**
$$\pi_{sname}\Bigl(\pi_{sid}\bigl(\sigma_{color='red' \vee color='green'}(parts) \bowtie catalog\bigr) \bowtie suppliers\Bigr)$$

**Consulta SQL:**
```
select s.sname 
from suppliers s
join catalog c on s.sid = c.sid
join parts p on c.pid = p.pid
where p.color = 'red' or p.color = 'green';
```

**10)**
$$\pi_{sname}\bigl(\sigma_{color='red'}(parts) \bowtie \sigma_{cost < 100}(catalog) \bowtie suppliers\bigr)$$

**Consulta SQL:**
```
select distinct s.sname 
from suppliers s
join catalog c on s.sid = c.sid
join parts p on c.pid = p.pid
where p.color = 'red' and c.cost < 100;
```

**11)**
$$\pi_{sname}(\sigma_{color='red'}(parts) \bowtie \sigma_{cost<100}(catalog) \bowtie suppliers);\cap;\pi_{sname}(\sigma_{color='green'}(parts) \bowtie \sigma_{cost<100}(catalog) \bowtie suppliers)$$

**Consulta SQL:**
```
select s.sname 
from suppliers s
join catalog c on s.sid = c.sid
join parts p on c.pid = p.pid
where p.color = 'red' and c.cost < 100
intersect
select s.sname 
from suppliers s
join catalog c on s.sid = c.sid
join parts p on c.pid = p.pid
where p.color = 'green' and c.cost < 100;
```

**12)**
$$\pi_{sid}(\sigma_{color='red'}(parts) \bowtie \sigma_{cost<100}(catalog));\cap;\pi_{sid}(\sigma_{color='green'}(parts) \bowtie \sigma_{cost<100}(catalog))$$

**Consulta SQL:**
```
select c.sid 
from catalog c
join parts p on c.pid = p.pid
where p.color = 'red' and c.cost < 100
intersect
select c.sid 
from catalog c
join parts p on c.pid = p.pid
where p.color = 'green' and c.cost < 100;
```

**13)**
$$\pi_{sid}(suppliers);-;\pi_{sid}(catalog)$$

**Consulta SQL:**
```
select sid from suppliers
except
select sid from catalog;
```

**14)**
$$\bigl(\pi_{sid}(catalog) \times \pi_{pid}(parts)\bigr);-;\pi_{sid,pid}(catalog)$$

**Consulta SQL:**
```
(select c.sid, p.pid 
 from catalog c, parts p)
except
select sid, pid 
from catalog;
```

**15)**
$$\pi_{name}\bigl(\sigma_{salary > 1000 \wedge age < 30}(employees)\bigr)$$

**Consulta SQL:**
```
select name 
from employees 
where salary > 1000 and age < 30;
```

**16)**
$$\pi_{b.name}\bigl(\rho_{b}(employees) \bowtie_{b.number=sv.boss} \rho_{sv}(supervises)\bigr)$$

**Consulta SQL:**
```
select distinct b.name 
from employees b
join supervises sv on b.number = sv.boss;
```

**17)**
$$\pi_{number}(employees);-;\pi_{boss}(supervises)$$

**Consulta SQL:**
```
select number from employees
except
select boss from supervises;
```

**18)**
$$\pi_{name, phone}\bigl(clients \bowtie \sigma_{service='haircut'}(appointments)\bigr)$$

**Consulta SQL:**
```
select distinct c.name, c.phone 
from clients c
join appointments a on c.cid = a.cid
where a.service = 'haircut';
```

**19)**
$$\pi_{cid}(clients);-;\pi_{cid}(appointments)$$

**Consulta SQL:**
```
select cid from clients
except
select cid from appointments;
```

**20)**
$$\pi_{c.name, s.name}\bigl(\rho_{c}(clients) \bowtie_{c.cid=a.cid} \rho_{a}(appointments) \bowtie_{a.sid=s.sid} \rho_{s}(staff)\bigr)$$

**Consulta SQL:**
```
select c.name as client_name, s.name as staff_name
from clients c
join appointments a on c.cid = a.cid
join staff s on a.sid = s.sid;
```

