/*a) Ahora veamos cómo ha quedado la tabla “superheroes” que creaste anteriormente. Para ello
necesitarás una consulta de tipo SELECT.*/
USE superheroes;
SELECT * FROM personajes;
SELECT * FROM creador;
/*b) Realiza una consulta que devuelva todos los valores de la columna “nombre_real” de la tabla
superhéroe.*/
SELECT nombre_real FROM personajes;
/*c) Realiza una consulta que devuelva todos los nombres reales de los personajes cuyo nombre
empieza con “B”.*/
select nombre_real FROM personajes WHERE nombre_real LIKE 'b%';