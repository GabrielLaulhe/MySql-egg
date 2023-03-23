/*Actividad 7p
Pongamos a prueba esta nueva cláusula: order by. Seguiremos trabajando con la tabla
“superhéroe”. Realiza una consulta que devuelva todos los registros ordenados por “inteligencia”.*/

USE superheroes;
select * FROM personajes ORDER BY inteligencia DESC; 
