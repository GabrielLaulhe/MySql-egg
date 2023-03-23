use nba;

#A continuación, se deben realizar las siguientes consultas sobre la base de datos:
#1. Mostrar el nombre de todos los jugadores ordenados alfabéticamente.
select * from jugadores;
#2. Mostrar el nombre de los jugadores que sean pivots (‘C’) y que pesen más de 200 libras,
#ordenados por nombre alfabéticamente.
select j.nombre from jugadores j where posicion ='c' and peso > 200 order by nombre;
#3. Mostrar el nombre de todos los equipos ordenados alfabéticamente.
select * from equipos;
#4. Mostrar el nombre de los equipos del este (East).
select nombre from equipos where ciudad='east';
#5. Mostrar los equipos donde su ciudad empieza con la letra ‘c’, ordenados por nombre.
select e.nombre from equipos where ciudad like 'c%';
#6. Mostrar todos los jugadores y su equipo ordenados por nombre del equipo.
select j.nombre, e.nombre from jugadores j, equipos e where e.nombre=j.Nombre_equipo order by e.nombre;
#7. Mostrar todos los jugadores del equipo “Raptors” ordenados por nombre.
select j.nombre, e.nombre from jugadores j, equipos e where e.nombre=j.Nombre_equipo and e.nombre='raptors' order by j.nombre;
#8. Mostrar los puntos por partido del jugador ‘Pau Gasol’.
select est.Puntos_por_partido, j.nombre, jugador from estadisticas est, jugadores j where est.jugador=j.codigo and j.nombre='Pau Gasol';
#9. Mostrar los puntos por partido del jugador ‘Pau Gasol’ en la temporada ’04/05′.
select est.Puntos_por_partido from estadisticas est, jugadores j where est.jugador=j.codigo and j.nombre='Pau Gasol' and temporada='04/05';
/*select temporada, Puntos_por_partido from estadisticas where jugador=66;*/  /*controlo que este bien la linea 22*/
#10. Mostrar el número de puntos de cada jugador en toda su carrera.
select est.Puntos_por_partido, est.temporada, j.nombre from estadisticas est, jugadores j where est.jugador=j.codigo order by j.nombre; #VER!!!

#11. Mostrar el número de jugadores de cada equipo.
select count(Nombre_equipo) as 'Cant. Jugadores', Nombre_equipo from jugadores group by nombre_equipo;
#12. Mostrar el jugador que más puntos ha realizado en toda su carrera.
select sum(Puntos_por_partido), e.jugador, j.nombre 
from estadisticas e, jugadores j where e.jugador=j.codigo group by e.jugador order by sum(Puntos_por_partido) desc limit 1 ;
#13. Mostrar el nombre del equipo, conferencia y división del jugador más alto de la NBA.
select e.Nombre, e.Conferencia, e.Division, j.Altura, j.nombre from equipos e, jugadores j 
where e.nombre=j.nombre_equipo order by j.altura desc limit 1;
#14. Mostrar la media de puntos en partidos de los equipos de la división Pacific.
select (avg(puntos_local)+avg(puntos_visitante))/2 as 'promedio por partido', e.nombre from equipos e, partidos p
where (e.nombre=p.equipo_local or e.nombre=p.equipo_visitante) and division in ('pacific') group by e.nombre;

#15. Mostrar el partido o partidos (equipo_local, equipo_visitante y diferencia) con mayor
#diferencia de puntos.
/*ALTERNATIVA 1*/
select equipo_local, equipo_visitante, puntos_local, puntos_visitante, max(puntos_local - puntos_visitante) as'diferencia' from partidos 
group by codigo order by max(puntos_local - puntos_visitante) desc limit 1;
/*ALTERNATIVA 2*/
select *, (puntos_local - puntos_visitante) as 'diferencia' from partidos 
where (puntos_local - puntos_visitante) =(select max(puntos_local - puntos_visitante) from partidos);
#16. Mostrar la media de puntos en partidos de los equipos de la división Pacific.
/*REPETIDO AL 14*/
#17. Mostrar los puntos de cada equipo en los partidos, tanto de local como de visitante.


select sum(total) as Total, equipo  from ( 
/* LO QUE SE HACE EN LAS SIGUIENTES TRES LINEAS ES traer una tabla con los puntos de local renombrando la columna como total, 
lo mismo con equipo local renombrano con equipo,
se trae ademas otra tabla con los puntos de visitante y el equipo. esas dos columnas renombradas con el mismo nombre que la columna de los puntos de local y de equipo
de esta forma se crea una sola tabla (total y equipo) con todos los datos unidos con la funcion union all.
luego que tenemos eso, trabajamos como una tabla normal segmentando y filtrando datos.*/
select puntos_local as total /*aca creo una nueva columna*/ , equipo_local as equipo /*crea una nueva columna*/ from partidos  /*renombrando todo con el mismo nombre me permite unir los dos resultados*/
union all
select puntos_visitante as total /*nombramos igual que la columna anterior*/, equipo_visitante as equipo /*lo mismo*/ from partidos ) as totales 
group by equipo;



#select sum(puntos_local) as total  from partidos group by equipo_local;
#select sum(puntos_visitante) as total  from partidos group by equipo_visitante; 


#18. Mostrar quien gana en cada partido (codigo, equipo_local, equipo_visitante,
#equipo_ganador), en caso de empate sera null.

/*https://www.youtube.com/watch?v=GYxmGpG0i8w&list=PLgqdACsQ8US3mPVgaBu8HiCk3pkeUjF33&index=43*/ /* VER VIDEO PARA RESOLVER*/

/*SE TRABAJA CON CONDICIONALES*/ /* EL CASE DEVUELVE ALGUNOS DE LOS RESULTADOS QUE ESTAN DESPUES DEL "THEN" SI SE CUMPLE LA CONDICION "WHEN"*/
select codigo, equipo_local, equipo_visitante, (case 
													when puntos_local>puntos_visitante then equipo_local
                                                    when puntos_local<puntos_visitante then equipo_visitante
                                                    when puntos_local=puntos_visitante then 'EMPATE'
                                                    end) as 'Equipo Ganador'
from partidos;