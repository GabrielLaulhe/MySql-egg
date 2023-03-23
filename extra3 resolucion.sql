use pokemondb;

#A continuación, se deben realizar las siguientes consultas:
#1. Mostrar el nombre de todos los pokemon.
select nombre from pokemon;
#2. Mostrar los pokemon que pesen menos de 10k.
select * from pokemon where peso<10;
#3. Mostrar los pokemon de tipo agua.
select p.nombre, t.nombre from pokemon p, tipo t, pokemon_tipo pt where p.numero_pokedex=pt.numero_pokedex and pt.id_tipo=t.id_tipo and t.nombre='agua';
#4. Mostrar los pokemon de tipo agua, fuego o tierra ordenados por tipo.
select p.nombre, t.nombre 
from pokemon p, tipo t, pokemon_tipo pt 
where (p.numero_pokedex=pt.numero_pokedex and pt.id_tipo=t.id_tipo) and t.nombre in ('agua','fuego','tierra') order by t.id_tipo;
#5. Mostrar los pokemon que son de tipo fuego y volador.
select p.nombre, t.nombre 
from pokemon p, tipo t, pokemon_tipo pt 
where (p.numero_pokedex=pt.numero_pokedex and pt.id_tipo=t.id_tipo) and t.nombre in ('fuego','volador');
#6. Mostrar los pokemon con una estadística base de ps mayor que 200.
select p.nombre, est.ps from pokemon p, estadisticas_base est where p.numero_pokedex=est.numero_pokedex and ps>200;
#7. Mostrar los datos (nombre, peso, altura) de la prevolución de Arbok.
/*select (case 
			when p.nombre='arbok' then e.pokemon_origen 
            when p.nombre!='arbok' then 0 end) as prevolucion
 from pokemon p, evoluciona_de e 
 where p.numero_pokedex=e.pokemon_evolucionado and 
 (case when p.nombre='arbok' then e.pokemon_origen when p.nombre!='arbok' then 0 end)!=0 ;*/
 #CON EL CODIGO ANTERIOR TRAIGO EL NUMERO DE LA PREVOLUCION, LUEGO LO COPIO EN EL WHERE DEL SIGUIENTE CODIGO PARA LA SUBCONSULTA.
 
select p.nombre, p.peso, p.altura
from pokemon p, evoluciona_de ev 
where p.numero_pokedex=ev.pokemon_origen 
and p.numero_pokedex=(select (case 
			when p.nombre='arbok' then e.pokemon_origen 
            when p.nombre!='arbok' then 0 end) as prevolucion
 from pokemon p, evoluciona_de e where p.numero_pokedex=e.pokemon_evolucionado and 
 (case when p.nombre='arbok' then e.pokemon_origen when p.nombre!='arbok' then 0 end)!=0 );
# OTRA ALTERNATIVA 
 SELECT p.nombre,p.peso, p.altura FROM pokemon p 
WHERE  p.numero_pokedex = (SELECT pokemon_origen FROM evoluciona_de
WHERE pokemon_evolucionado = (SELECT numero_pokedex FROM pokemon WHERE nombre LIKE 'Arbok' ))
;

 
#8. Mostrar aquellos pokemon que evolucionan por intercambio.
select p.numero_pokedex, p.nombre from tipo_evolucion t, forma_evolucion f, pokemon_forma_evolucion pe, pokemon p
where t.tipo_evolucion='intercambio' and f.tipo_evolucion=t.id_tipo_evolucion and pe.id_forma_evolucion=f.id_forma_evolucion and pe.numero_pokedex=p.numero_pokedex;
#9. Mostrar el nombre del movimiento con más prioridad.
select nombre from movimiento order by prioridad desc limit 1;
#10. Mostrar el pokemon más pesado.
select nombre from pokemon where peso order by peso desc limit 1;
#11. Mostrar el nombre y tipo del ataque con más potencia.
select m.nombre, m.id_tipo, t.nombre, ta.tipo from movimiento m, tipo t, tipo_ataque ta 
where m.id_tipo=t.id_tipo and t.id_tipo_ataque=ta.id_tipo_ataque order by potencia desc limit 1;
#12. Mostrar el número de movimientos de cada tipo.

select m.id_movimiento, m.nombre, t.nombre as tipo from movimiento m, tipo t where m.id_tipo=t.id_tipo order by m.id_tipo;

select count(m.id_tipo), m.id_tipo, t.nombre from movimiento m, tipo t where m.id_tipo=t.id_tipo group by m.id_tipo;

#13. Mostrar todos los movimientos que puedan envenenar.
select m.nombre as mov
from movimiento m, tipo t, efecto_secundario ef, movimiento_efecto_secundario mef 
where m.id_tipo=t.id_tipo and t.nombre='veneno'
or (ef.efecto_secundario like '%envenenamiento%' and ef.id_efecto_secundario=mef.id_efecto_secundario and mef.id_movimiento=m.id_movimiento);

select m.nombre as mov
from movimiento m, efecto_secundario ef, movimiento_efecto_secundario mef 
where ef.efecto_secundario like '%envenenamiento%' and ef.id_efecto_secundario=mef.id_efecto_secundario and mef.id_movimiento=m.id_movimiento;

/* UNION DE LOS DOS RESULTADOS ANTERIORES PARA UNIR DOS LISTAS DE MOVIMIENTOS QUE ENVENENAN*/
select *
from  (
select m.nombre as mov from movimiento m, tipo t, efecto_secundario ef, movimiento_efecto_secundario mef  where m.id_tipo=t.id_tipo and t.nombre='veneno'
union all
select m.nombre as mov from movimiento m, efecto_secundario ef, movimiento_efecto_secundario mef  where ef.efecto_secundario like '%envenenamiento%' and ef.id_efecto_secundario=mef.id_efecto_secundario and mef.id_movimiento=m.id_movimiento
) as unionLista
group by mov;
#14. Mostrar todos los movimientos que causan daño, ordenados alfabéticamente por nombre.
select * from movimiento where descripcion like '%causa daño%' order by nombre;
#15. Mostrar todos los movimientos que aprende pikachu.
select distinct m.* from movimiento m, pokemon_movimiento_forma pmf, pokemon p 
where p.nombre='pikachu' and p.numero_pokedex=pmf.numero_pokedex and pmf.id_movimiento=m.id_movimiento;

#16. Mostrar todos los movimientos que aprende pikachu por MT (tipo de aprendizaje).
select m.* from movimiento m, pokemon_movimiento_forma pmf, forma_aprendizaje fa, tipo_forma_aprendizaje tfa, pokemon p 
where p.nombre='pikachu' and p.numero_pokedex=pmf.numero_pokedex and pmf.id_forma_aprendizaje=fa.id_forma_aprendizaje and fa.id_tipo_aprendizaje=tfa.id_tipo_aprendizaje
and tipo_aprendizaje='mt' and pmf.id_movimiento=m.id_movimiento;
#17. Mostrar todos los movimientos de tipo normal que aprende pikachu por nivel.
select m.* from pokemon p, pokemon_movimiento_forma pmf, movimiento m, tipo t, forma_aprendizaje fa, tipo_forma_aprendizaje tfa 
where p.nombre='pikachu' and p.numero_pokedex=pmf.numero_pokedex and pmf.id_movimiento=m.id_movimiento and m.id_tipo=t.id_tipo and t.nombre='normal'
and pmf.id_forma_aprendizaje=fa.id_forma_aprendizaje and fa.id_tipo_aprendizaje=tfa.id_tipo_aprendizaje and tfa.tipo_aprendizaje='nivel';
#18. Mostrar todos los movimientos de efecto secundario cuya probabilidad sea mayor al 30%.
select m.* from movimiento m, movimiento_efecto_secundario mes where mes.id_movimiento=m.id_movimiento and mes.probabilidad>30;
#19. Mostrar todos los pokemon que evolucionan por piedra.
select distinct p.* from pokemon p, pokemon_forma_evolucion pfe, forma_evolucion fe, tipo_evolucion te
where te.tipo_evolucion='piedra' and te.id_tipo_evolucion=fe.tipo_evolucion and fe.id_forma_evolucion=pfe.id_forma_evolucion and pfe.numero_pokedex=p.numero_pokedex;
#20. Mostrar todos los pokemon que no pueden evolucionar.
select p.numero_pokedex, p.nombre from pokemon p 
left join pokemon_forma_evolucion pfe on p.numero_pokedex=pfe.numero_pokedex
where pfe.numero_pokedex is null;



select p.* from pokemon p, pokemon_forma_evolucion pfe, forma_evolucion fe, tipo_evolucion te
where p.numero_pokedex=pfe.numero_pokedex and pfe.id_forma_evolucion=fe.id_forma_evolucion 
and fe.tipo_evolucion=te.id_tipo_evolucion and te.tipo_evolucion in ('nivel','piedra','intercambio') order by p.numero_pokedex;

#21. Mostrar la cantidad de los pokemon de cada tipo.
select count(t.nombre), t.id_tipo, t.nombre from pokemon p, pokemon_tipo pt, tipo t
where p.numero_pokedex=pt.numero_pokedex and pt.id_tipo=t.id_tipo group by t.id_tipo;
