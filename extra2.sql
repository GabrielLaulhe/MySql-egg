use jardineria;

/*Consultas sobre una tabla*/
/*1. Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.*/
select codigo_oficina, ciudad from oficina;
/*2. Devuelve un listado con la ciudad y el teléfono de las oficinas de España.*/
select ciudad, telefono from oficina where pais='España';
/*3. Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un
código de jefe igual a 7.*/
select nombre, apellido1, apellido2, email from empleado where codigo_jefe=7;
/*4. Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa.*/
select puesto, nombre, apellido1, apellido2, email from empleado where codigo_jefe is null;
/*5. Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean
representantes de ventas.*/
select nombre, apellido1, apellido2, puesto from empleado where puesto not in('representante ventas');
#6. Devuelve un listado con el nombre de los todos los clientes españoles.
select nombre_cliente from cliente where pais='spain';
#7. Devuelve un listado con los distintos estados por los que puede pasar un pedido.
select distinct(estado) from pedido;
#8. Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago
#en 2008. Tenga en cuenta que deberá eliminar aquellos códigos de cliente que aparezcan
#repetidos. Resuelva la consulta:
#o Utilizando la función YEAR de MySQL.
select codigo_cliente from pago where year(fecha_pago)=2008;
#o Utilizando la función DATE_FORMAT de MySQL.
select codigo_cliente from pago where date_format(fecha_pago,'%Y')=2008; /*poner con mayuscula la fecha sino no funciona*/
#o Sin utilizar ninguna de las funciones anteriores.
select codigo_cliente from pago where fecha_pago like '%2008%';
#9. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de
#entrega de los pedidos que no han sido entregados a tiempo.
select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega from pedido where fecha_entrega>fecha_esperada; 
#10. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de
#entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha
#esperada.
#o Utilizando la función ADDDATE de MySQL.
select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega from pedido where fecha_esperada>=adddate(fecha_entrega, interval 2 DAY); 
/*al pedir que la fecha de entrega sea menor 
que la fecha esperada, armamos un intervalo de dos dias de la fecha de entrega y 
pedimos que la fecha esperada sea mayor que eso. Es una forma para que se cumpla la condicion*/

#o Utilizando la función DATEDIFF de MySQL.
select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega from pedido where datediff(fecha_esperada, fecha_entrega)>=2 and fecha_entrega<fecha_esperada;
/*datediff saca la diferencia entre dos fechas*/
#11. Devuelve un listado de todos los pedidos que fueron rechazados en 2009.
select * from pedido where estado='rechazado' and fecha_pedido like '%2009%';
#12. Devuelve un listado de todos los pedidos que han sido entregados en el mes de enero de
#cualquier año.
select * from pedido where estado='entregado' and date_format(fecha_entrega,'%m')=01; /*el mes va con minuscula*/
#13. Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal.
#Ordene el resultado de mayor a menor.
select * from pago where fecha_pago like '%2008%' and forma_pago='PayPal' order by fecha_pago desc;
#14. Devuelve un listado con todas las formas de pago que aparecen en la tabla pago. Tenga en
#cuenta que no deben aparecer formas de pago repetidas.
select distinct forma_pago from pago;
#15. Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que
#tienen más de 100 unidades en stock. El listado deberá estar ordenado por su precio de
#venta, mostrando en primer lugar los de mayor precio.
select * from producto where gama='Ornamentales' and cantidad_en_stock>100 order by precio_venta desc;
#16. Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo
#representante de ventas tenga el código de empleado 11 o 30.
select * from cliente where ciudad='madrid' and (codigo_empleado_rep_ventas=11 or codigo_empleado_rep_ventas=30);


/*Consultas multitabla (Composición interna)
Las consultas se deben resolver con INNER JOIN.*/

/*1. Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante
de ventas.*/
select c.nombre_cliente, e.nombre, e.apellido1, e.apellido2, e.puesto from cliente c
inner join empleado e on c.codigo_empleado_rep_ventas=e.codigo_empleado
where e.puesto like 'representante ventas';

/*2. Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus
representantes de ventas.*/
select distinct c.nombre_cliente, e.nombre, e.apellido1, e.apellido2, e.puesto from cliente c
inner join empleado e on c.codigo_empleado_rep_ventas=e.codigo_empleado
inner join pago p on c.codigo_cliente=p.codigo_cliente
where e.puesto like 'representante ventas';

/*3. Muestra el nombre de los clientes que no hayan realizado pagos junto con el nombre de
sus representantes de ventas.*/
select distinct c.nombre_cliente, e.nombre, e.apellido1, e.apellido2, e.puesto from cliente c
inner join empleado e on c.codigo_empleado_rep_ventas=e.codigo_empleado
where e.puesto like 'representante ventas'  and c.codigo_cliente not in (select codigo_cliente from pago);

/*4. Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes
junto con la ciudad de la oficina a la que pertenece el representante.*/
select distinct c.nombre_cliente, e.nombre, e.apellido1, e.apellido2, e.puesto, o.ciudad from cliente c
inner join empleado e on c.codigo_empleado_rep_ventas=e.codigo_empleado
inner join pago p on c.codigo_cliente=p.codigo_cliente
inner join oficina o on o.codigo_oficina=e.codigo_oficina
where e.puesto like 'representante ventas';

/*5. Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus
representantes junto con la ciudad de la oficina a la que pertenece el representante.*/
select c.nombre_cliente, e.nombre, e.apellido1, e.apellido2, e.puesto, o.ciudad, c.codigo_cliente from cliente c
inner join empleado e on c.codigo_empleado_rep_ventas=e.codigo_empleado
inner join oficina o on o.codigo_oficina=e.codigo_oficina
where e.puesto like 'representante ventas'  and c.codigo_cliente not in (select codigo_cliente from pago) order by c.codigo_cliente ;

#6. Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.
select distinct c.nombre_cliente, o.linea_direccion1, o.linea_direccion2, c.ciudad from oficina o 
inner join empleado e on e.codigo_oficina=o.codigo_oficina
inner join cliente c on c.codigo_empleado_rep_ventas=e.codigo_empleado
where c.ciudad like 'fuenlabrada';

#7. Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad
#de la oficina a la que pertenece el representante.
select c.nombre_cliente, e.nombre, e.apellido1, e.apellido2, o.ciudad, e.puesto from cliente c
inner join empleado e on c.codigo_empleado_rep_ventas=e.codigo_empleado
inner join oficina o on e.codigo_oficina=o.codigo_oficina
where e.puesto like 'representante ventas';
#8. Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.
select e.nombre, e.apellido1, e.apellido2, e1.nombre, e1.apellido1,e1.apellido2, e1.puesto from empleado e
inner join empleado e1 on e.codigo_jefe=e1.codigo_empleado;

#9. Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.
select distinct c.nombre_cliente, p.fecha_esperada, p.fecha_entrega from cliente c
inner join pedido p on c.codigo_cliente=p.codigo_cliente
where p.fecha_entrega>p.fecha_esperada;
#10. Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.
select distinct p.gama, c.nombre_cliente  from producto p
inner join detalle_pedido dp on p.codigo_producto=dp.codigo_producto
inner join pedido pp on dp.codigo_pedido=pp.codigo_pedido
inner join cliente c on c.codigo_cliente=pp.codigo_cliente;

/*Consultas multitabla (Composición externa)
Resuelva todas las consultas utilizando las cláusulas LEFT JOIN, RIGHT JOIN, JOIN.*/
#1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
select distinct c.nombre_cliente from cliente c
left join pago p on c.codigo_cliente=p.codigo_cliente
where p.codigo_cliente is null;

#2. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pedido.
select distinct c.nombre_cliente from cliente c
left join pedido p on c.codigo_cliente=p.codigo_cliente
where p.codigo_cliente is null;
#3. Devuelve un listado que muestre los clientes que no han realizado ningún pago y los que
#no han realizado ningún pedido.
select distinct c.nombre_cliente from cliente c
left join pago p on c.codigo_cliente=p.codigo_cliente
left join pedido pp on c.codigo_cliente=pp.codigo_cliente
where (p.codigo_cliente and pp.codigo_cliente) is null;
#4. Devuelve un listado que muestre solamente los empleados que no tienen una oficina
#asociada.
select e.nombre, e.apellido1, e.apellido2 from empleado e
left join oficina o on e.codigo_oficina=o.codigo_oficina
where o.codigo_oficina is null;

#5. Devuelve un listado que muestre solamente los empleados que no tienen un cliente
#asociado.
select e.* from empleado e
left join cliente c on e.codigo_empleado=c.codigo_empleado_rep_ventas
where c.codigo_empleado_rep_ventas is null;
#6. Devuelve un listado que muestre los empleados que no tienen una oficina asociada y los
#que no tienen un cliente asociado.
select e.* from empleado e
left join cliente c on e.codigo_empleado=c.codigo_empleado_rep_ventas
left join oficina o on e.codigo_oficina=o.codigo_oficina
where (c.codigo_empleado_rep_ventas and o.codigo_oficina) is null;
#7. Devuelve un listado de los productos que nunca han aparecido en un pedido.
select p.* from producto p
left join detalle_pedido dp on p.codigo_producto=dp.codigo_producto
where dp.codigo_producto is null;
#8. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los
#representantes de ventas de algún cliente que haya realizado la compra de algún producto
#de la gama Frutales.
select distinct o.codigo_oficina from oficina o
join empleado e on o.codigo_oficina=e.codigo_oficina
left join cliente c on e.codigo_empleado=c.codigo_empleado_rep_ventas
where o.codigo_oficina not in (select distinct o.codigo_oficina from oficina o
join empleado e on o.codigo_oficina=e.codigo_oficina
join cliente c on e.codigo_empleado=c.codigo_empleado_rep_ventas
join pedido p on c.codigo_cliente=p.codigo_cliente
join detalle_pedido dp on p.codigo_pedido=dp.codigo_pedido
join producto prod on dp.codigo_producto=prod.codigo_producto
where prod.gama like 'frutales');
# SUBCONSULTA = PRODUCTOS FRUTALES COMPRADOS EN OFICINAS
/*select distinct o.codigo_oficina from oficina o
join empleado e on o.codigo_oficina=e.codigo_oficina
join cliente c on e.codigo_empleado=c.codigo_empleado_rep_ventas
join pedido p on c.codigo_cliente=p.codigo_cliente
join detalle_pedido dp on p.codigo_pedido=dp.codigo_pedido
join producto prod on dp.codigo_producto=prod.codigo_producto
where prod.gama like 'frutales'*/


#9. Devuelve un listado con los clientes que han realizado algún pedido, pero no han realizado
#ningún pago.
select distinct c.* from cliente c
join pedido p on c.codigo_cliente=p.codigo_cliente
left join pago pp on c.codigo_cliente=pp.codigo_cliente
where pp.codigo_cliente is null;

#10. Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el
#nombre de su jefe asociado.
select e.*, e1.nombre, e1.apellido1 from empleado e
join empleado e1 on e1.codigo_empleado=e.codigo_jefe
left join cliente c on c.codigo_empleado_rep_ventas=e.codigo_empleado
where c.codigo_empleado_rep_ventas is null;

#Consultas resumen
# 1. ¿Cuántos empleados hay en la compañía?
select count(codigo_empleado) as 'Cant Empleados' from empleado;
# 2. ¿Cuántos clientes tiene cada país?
select count(c.nombre_cliente) as 'Cant. Clientes por Pais', c.pais from cliente c group by c.pais;
# 3. ¿Cuál fue el pago medio en 2009?
select avg(p.total) as 'Pago promedio en 2009'from pago p
where p.fecha_pago like '2009%';
# 4. ¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma descendente por el
# número de pedidos.
select count(p.codigo_pedido) as 'Cant pedidos x Estado', p.estado from pedido p group by p.estado;
# 5. Calcula el precio de venta del producto más caro y más barato en una misma consulta.
select max(p.precio_venta), min(p.precio_venta) from producto p;
# 6. Calcula el número de clientes que tiene la empresa.
select count(c.codigo_cliente) from cliente c;
# 7. ¿Cuántos clientes tiene la ciudad de Madrid?
select count(c.codigo_cliente), c.ciudad from cliente c
where c.ciudad='madrid';
# 8. ¿Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M?
select count(c.codigo_cliente) as 'Cant Cliente por Ciudad', c.ciudad from cliente c
where c.ciudad like 'm%' group by c.ciudad;
# 9. Devuelve el nombre de los representantes de ventas y el número de clientes al que atiende
# cada uno.

select count(c.codigo_cliente), e.nombre, e.apellido1, e.apellido2, e.codigo_empleado from empleado e, cliente c
where e.codigo_empleado=c.codigo_empleado_rep_ventas and e.puesto like '%representante ventas%' group by e.codigo_empleado;

# 10. Calcula el número de clientes que no tiene asignado representante de ventas.
select count(c.codigo_cliente) from cliente c
left join empleado e on c.codigo_empleado_rep_ventas=e.codigo_empleado
where e.puesto like '%representante ventas%' and c.codigo_empleado_rep_ventas is null;

select count(c.codigo_cliente) from cliente c
left join empleado e on c.codigo_empleado_rep_ventas=e.codigo_empleado
where e.puesto not like '%representante ventas%';

# 11. Calcula la fecha del primer y último pago realizado por cada uno de los clientes. El listado
# deberá mostrar el nombre y los apellidos de cada cliente.
select max(p.fecha_pago) as 'Ultimo Pago', min(p.fecha_pago) as 'Primer Pago', c.nombre_cliente, c.apellido_contacto, c.codigo_cliente  from pago p
join cliente c on p.codigo_cliente=c.codigo_cliente group by c.codigo_cliente;

# 12. Calcula el número de productos diferentes que hay en cada uno de los pedidos.
select count(dp.codigo_producto), p.codigo_pedido from detalle_pedido dp
join pedido p on dp.codigo_pedido=p.codigo_pedido group by p.codigo_pedido;

# 13. Calcula la suma de la cantidad total de todos los productos que aparecen en cada uno de
# los pedidos.
select sum(dp.cantidad), p.codigo_pedido from detalle_pedido dp
join pedido p on dp.codigo_pedido=p.codigo_pedido group by p.codigo_pedido;
# 14. Devuelve un listado de los 20 productos más vendidos y el número total de unidades que
# se han vendido de cada uno. El listado deberá estar ordenado por el número total de
# unidades vendidas.
select count(dp.codigo_producto)*sum(dp.cantidad), dp.codigo_producto from detalle_pedido dp group by dp.codigo_producto 
order by count(dp.codigo_producto)*sum(dp.cantidad) desc limit 20;
# 15. La facturación que ha tenido la empresa en toda la historia, indicando la base imponible, el
# IVA y el total facturado. La base imponible se calcula sumando el coste del producto por el
# número de unidades vendidas de la tabla detalle_pedido. El IVA es el 21 % de la base
# imponible, y el total la suma de los dos campos anteriores.
select sum(dp.cantidad*dp.precio_unidad) as BI, sum(dp.cantidad*dp.precio_unidad)*0.21 as IVA, 
sum(dp.cantidad*dp.precio_unidad) + sum(dp.cantidad*dp.precio_unidad)*0.21 as 'Total Facturado'
from detalle_pedido dp;

# 16. La misma información que en la pregunta anterior, pero agrupada por código de producto.
select dp.codigo_producto, sum(dp.cantidad*dp.precio_unidad) as BI, sum(dp.cantidad*dp.precio_unidad)*0.21 as IVA, 
sum(dp.cantidad*dp.precio_unidad) + sum(dp.cantidad*dp.precio_unidad)*0.21 as 'Total Facturado'
from detalle_pedido dp group by dp.codigo_producto;

# 17. La misma información que en la pregunta anterior, pero agrupada por código de producto
# filtrada por los códigos que empiecen por OR.
select dp.codigo_producto, sum(dp.cantidad*dp.precio_unidad) as BI, sum(dp.cantidad*dp.precio_unidad)*0.21 as IVA, 
sum(dp.cantidad*dp.precio_unidad) + sum(dp.cantidad*dp.precio_unidad)*0.21 as 'Total Facturado'
from detalle_pedido dp where dp.codigo_producto like 'OR%' group by dp.codigo_producto;
# 18. Lista las ventas totales de los productos que hayan facturado más de 3000 euros. Se
# mostrará el nombre, unidades vendidas, total facturado y total facturado con impuestos (21%
# IVA).
select dp.codigo_producto, p.nombre, sum(dp.cantidad), sum(dp.cantidad*dp.precio_unidad) as 'BI', sum(dp.cantidad*dp.precio_unidad)*0.21 as 'IVA', 
sum(dp.cantidad*dp.precio_unidad) + sum(dp.cantidad*dp.precio_unidad)*0.21 as 'Total Facturado'
from detalle_pedido dp 
join producto p on dp.codigo_producto=p.codigo_producto
group by p.codigo_producto having (sum(dp.cantidad*dp.precio_unidad) + sum(dp.cantidad*dp.precio_unidad)*0.21)>3000;

# Subconsultas con operadores básicos de comparación
# 1. Devuelve el nombre del cliente con mayor límite de crédito.
select c.nombre_cliente, c.limite_credito from cliente c 
where c.limite_credito=(select c.limite_credito from cliente c order by c.limite_credito desc limit 1);

# 2. Devuelve el nombre del producto que tenga el precio de venta más caro.
select p.nombre, p.precio_venta from producto p 
where p.precio_venta=(select p.precio_venta from producto p order by p.precio_venta desc limit 1);

# 3. Devuelve el nombre del producto del que se han vendido más unidades. (Tenga en cuenta
# que tendrá que calcular cuál es el número total de unidades que se han vendido de cada
# producto a partir de los datos de la tabla detalle_pedido. Una vez que sepa cuál es el código
# del producto, puede obtener su nombre fácilmente.)

/* Subconsulta*/
select codigo_producto from detalle_pedido dp group by dp.codigo_producto order by sum(dp.cantidad) desc limit 1;
# Resolucion
select distinct p.codigo_producto, p.nombre, sum(dp.cantidad) from producto p, detalle_pedido dp
where p.codigo_producto=dp.codigo_producto 
and p.codigo_producto= (select codigo_producto from detalle_pedido dp group by dp.codigo_producto order by sum(dp.cantidad) desc limit 1);


# 4. Los clientes cuyo límite de crédito sea mayor que los pagos que haya realizado. (Sin utilizar
# INNER JOIN).
select c.nombre_cliente, c.codigo_cliente, sum(p.total), c.limite_credito from cliente c, pago p
where c.codigo_cliente=p.codigo_cliente
group by c.codigo_cliente having c.limite_credito > sum(p.total);
# 5. Devuelve el producto que más unidades tiene en stock.
select p.nombre, p.cantidad_en_stock from producto p
where p.codigo_producto = (select p.codigo_producto from producto p order by p.cantidad_en_stock desc limit 1);

# 6. Devuelve el producto que menos unidades tiene en stock.
select p.nombre, p.cantidad_en_stock from producto p
where p.codigo_producto = (select p.codigo_producto from producto p order by p.cantidad_en_stock limit 1);
# 7. Devuelve el nombre, los apellidos y el email de los empleados que están a cargo de Alberto Soria.
select e.codigo_empleado, e.nombre, e.apellido1, e.apellido2, e.email from empleado e 
where e.codigo_jefe= (select e.codigo_empleado from empleado e where e.nombre like '%alberto%' and e.apellido1 like '%soria%' );


# Subconsultas con ALL y ANY
# 1. Devuelve el nombre del cliente con mayor límite de crédito.
select c.nombre_cliente, c.limite_credito from cliente c 
where c.limite_credito>= ALL (select c.limite_credito from cliente c);

select c.nombre_cliente, c.limite_credito from cliente c 
where c.limite_credito>= ANY (select max(c.limite_credito) from cliente c);

# 2. Devuelve el nombre del producto que tenga el precio de venta más caro.
select p.nombre, p.precio_venta from producto p 
where p.precio_venta>= ALL (select p.precio_venta from producto p);

select p.nombre, p.precio_venta
from producto p 
where p.precio_venta = ANY(select max(precio_venta) from producto);

# 3. Devuelve el producto que menos unidades tiene en stock.
select p.nombre, p.cantidad_en_stock from producto p
where p.cantidad_en_stock <= ALL (select p.cantidad_en_stock from producto p);

select p.nombre, p.cantidad_en_stock from producto p
where p.cantidad_en_stock <= ANY (select min(p.cantidad_en_stock) from producto p);

# Subconsultas con IN y NOT IN
# 1. Devuelve el nombre, apellido1 y cargo de los empleados que no representen a ningún
# cliente.
select e.nombre, e.apellido1, e.puesto from empleado e where e.codigo_empleado not in (select c.codigo_empleado_rep_ventas from cliente c);
# 2. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
select c.* from cliente c where c.codigo_cliente not in (select p.codigo_cliente from pago p);
# 3. Devuelve un listado que muestre solamente los clientes que sí han realizado ningún pago.
select c.* from cliente c where c.codigo_cliente in (select p.codigo_cliente from pago p);
# 4. Devuelve un listado de los productos que nunca han aparecido en un pedido.
select distinct p.nombre from producto p where p.codigo_producto not in (select distinct dp.codigo_producto from detalle_pedido dp);
# 5. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean representante de ventas de ningún cliente.
select e.nombre, e.apellido1, e.apellido2, o.telefono, e.puesto from empleado e, oficina o
where e.codigo_empleado not in (select c.codigo_empleado_rep_ventas from cliente c) and e.codigo_oficina=o.codigo_oficina;
# Subconsultas con EXISTS y NOT EXISTS
# 1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún
# pago.
select distinct c.* from cliente c, pago p where not exists (select p.codigo_cliente from pago p where c.codigo_cliente=p.codigo_cliente);
# 2. Devuelve un listado que muestre solamente los clientes que sí han realizado ningún pago.
select distinct c.* from cliente c, pago p where exists (select p.codigo_cliente from pago p where c.codigo_cliente=p.codigo_cliente);
# 3. Devuelve un listado de los productos que nunca han aparecido en un pedido.
select p.* from producto p where not exists (select dp.codigo_producto from detalle_pedido dp where p.codigo_producto=dp.codigo_producto);
# 4. Devuelve un listado de los productos que han aparecido en un pedido alguna vez.
select p.* from producto p where exists (select dp.codigo_producto from detalle_pedido dp where p.codigo_producto=dp.codigo_producto);