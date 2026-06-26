 ## **Sección 1: SQL -> Álgebra Relacional**

**1) Vuelos cuyo destino es New Delhi**
```
select * from flight
where dest = 'New Delhi'
```

**Algebra Relacional:**
$$\sigma_{dest = 'New Delhi'}(flight)$$

**2) Nombres de pasajeros con al menos una reserva**
```
select distinct p.pname from passenger p
join booking b on b.pid = p.pid;
```

**Algebra Relacional:**
$$\pi_{pname}(passenger \bowtie booking)$$

**3) Vuelos que operan a las 16:00 tanto el 2020-12-01 como el 2020-12-02**
```
select * from flight where fdate = date '2020-12-01' and time = '16:00'
intersect
select * from flight where fdate = date '2020-12-02' and time = '16:00';
```

**Algebra Relacional:**
$$\sigma_{fdate = '2020\text{-}12\text{-}01' \wedge time = '16:00'}(flight) \cap \sigma_{fdate = '2020\text{-}12\text{-}02' \wedge time = '16:00'}(flight)$$

**4) Pasajeros sin reservas (pid y nombre)**
```
select p.pid, p.name from passenger p
where p.pid not in (select pid from booking);
```

**Algebra Relacional:**
$$\pi_{pid, pname}(passenger) - \pi_{pid, pname}(passenger \bowtie booking)$$

**5) Pasajeros masculinos asociados a la agencia 'Jet'**
```
select distinct p.pid, p.pname, p.pcity from passenger p
join booking b on b.pid = p.pid
join agency a on a.aid= b.aid
where p.pgender = 'Male' and a.anme = 'Jet';
```

**Algreba Relacional:**
$$\pi_{pid, pname, pcity}(\sigma_{pgender = 'Male'}(passenger) \bowtie booking \bowtie \sigma_{aname = 'Jet'}(agency))$$

## **Sección 2: Algebra Relacional -> SQL**

**1) Agencias en Delhi con vuelos a Mumbai:**
$$\pi_{aname}(\sigma_{acity = 'Delhi'}(agency) \bowtie booking \bowtie \sigma_{dest = 'Mumbai'}(flight))$$

**Consulta SQL:**
```
select distinct a.aname from agency a
join booking b on a.aid = b.aid
join flight f on b.fid = f.fid
where a.acity = 'Delhi' and f.dest = 'Mumbai';
```

**2)Pasajeros que han reservado vuelos con agencias en su misma ciudad:**
$$\pi_{pname}(passenger \bowtie_{passenger.pid = booking.pid \wedge passenger.pcity = agency.acity} booking \bowtie agency)$$

**Consulta en SQL:**
```
select distinct p.pname from passenger p
join booking b on p.pid = b.pid
join agency a on b.aid = a.aid
where p.pcity = a.acity
```

**3)Pasajeros que han reservado vuelos saliendo desde su propia ciudad**
$$\pi_{pname}(passenger \bowtie_{passenger.pid = booking.pid \wedge passenger.pcity = flight.src} booking \bowtie flight)$$

**Consulta en SQL:**
```
select distinct p.pname from passenger p
join booking b on p.pid = b.pid
join flight f on b.fid = f.fid
where p.pcity = f.src;
```

**4)Agencias que están en la misma ciudad que el pasajero '123'**
$$\pi_{aname}(agency \bowtie_{agency.acity = passenger.pcity} \sigma_{pid = '123'}(passenger))$$

**Consulta en SQL:**
```
select a.aname from agency a
join passenger p on a.acity = p.pcity
where p.pid = '123';
```

**5)Agencias en las que el pasajero '123' no tiene reservas**
$$\pi_{aid, aname}(agency) - \pi_{aid, aname}(agency \bowtie \sigma_{pid = '123'}(booking))$$

**Consulta en SQL:**
```
select a.aid, a.aname from agency a
where a.aid not in(
  select b.aid from booking b
  where b.pid = '123'
);
```








