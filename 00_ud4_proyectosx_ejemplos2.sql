/*EJEMPLOS UNIDAD 4 - REALIZACIÓN DE CONSULTAS */
/* ----------------------------------------------*/

USE proyectosx;

/***** CONSULTAS MULTITABLA -- con JOIN o con WHERE ***********/
/*Consulta a varias tablas que están relacionadas por alguna columna*/

-- 1)
/* Listado con el código y nombre de cada empleado y el código y nombre de su departamento
Para los empleados que tienen departamento*/

/* IMPORTANTE: como hay columnas que se denominan de igual forma en ambas tablas, 
 hay que calificarlas anteponiendo el nombre de la tabla 
 o bien con una alias de tabla (lo vemos después)
 */
-- 1a) con JOIN
SELECT empleado.cdemp, empleado.nombre, departamento.cddep, departamento.nombre 
FROM empleado
JOIN departamento ON empleado.cddep=departamento.cddep;

-- 1b) con WHERE
SELECT empleado.cdemp, empleado.nombre, departamento.cddep, departamento.nombre 
FROM empleado, departamento
WHERE empleado.cddep=departamento.cddep;

/**** IMPORTANTE: hay que tener cuidado con no hacer un Producto Cartesiano de tablas,
cuando se hace una consulta a varias tablas utilizando WHERE.
El producto cartesiano lo que hace es combinar cada fila de una tabla con todas las filas de otra tabla***/

-- la siguiente solución NO es correcta, hace un producto cartesiano
select empleado.cdemp, empleado.nombre, departamento.cddep, departamento.nombre 
FROM empleado, departamento;
-- observa que no tiene mucho sentido el resultado de esta consulta 
-- (combina a cada empleado con todos los departamentos)
-- se deberían mostrar sólo las filas relacionadas
-- lo que ha hecho esta consulta es el producto cartesiano de las dos tablas

/* ¿Cómo mostrar sólo las filas relacionadas?
a) Mediante WHERE, igualando las columnas que deben coincidir (relacionadas)
o bien
b) Mediante JOIN, igualando las columnas que deben coincidir (relacionadas)
*/
/****** el uso de JOIN también se denomina 'composiciones SQL99' *****/

-- 2)
/* La consulta 1) pero calificando con alias de tabla
*/
-- calificando columna con alias de tabla 
-- (se pone detrás del nombre de la tabla y suele ser la primera letra)

-- con JOIN
SELECT e.cdemp, e.nombre, d.nombre  
FROM empleado e -- el alias de tabla es la e 
INNER JOIN departamento d ON e.cddep=d.cddep;

-- con WHERE
SELECT e.cdemp, e.nombre,  d.nombre
FROM empleado e, departamento d
WHERE e.cddep=d.cddep;

/*** Composiciones INTERNAS -- con INNER JOIN o WHERE***/
/*Combina tablas por las columnas indicadas y sólo muestra o lista los datos
de las filas que están relacionadas por esas columnas y en las que
hay coincidencia de valores en las columnas indicadas
- Se puede componer o combinar cualquier número de tablas*/

-- 3)
/*Para los empleados con departamento, mostrar su código, nombre, fecha de ingreso, 
nombre de departamento y ciudad.*/

-- con WHERE
SELECT e.cdemp, e.nombre, e.fecha_ingreso, d.nombre, d.ciudad
FROM empleado e, departamento d
WHERE e.cddep= d.cddep; -- si no ponemos la columnas que relacionan las tablas, hacemos producto cartesiano-- MAL

-- con INNER JOIN
/*INNER JOIN: Mediante índices combina directamente las filas
coincidentes en el campo o columna de combinación, agilizando el proceso 
*/

SELECT e.cdemp, e.nombre, e.fecha_ingreso, d.nombre, d.ciudad
FROM empleado e
INNER JOIN departamento d ON e.cddep= d.cddep;

-- 4) La consulta anterior pero sólo para los empleados de salario mayor a 1500

-- con WHERE: 
-- tanto la combinación de tablas como el criterio o condición de filtro debe ir en el WHERE 

SELECT e.cdemp, e.nombre, e.fecha_ingreso, d.nombre, d.ciudad
FROM empleado e, departamento d
WHERE e.cddep= d.cddep AND e.salario> 1500; -- hay que poner el filtro y la forma de combinar las tablas

/* con JOIN: es más legible, pues el filtro se indica en WHERE 
 y la forma de combinar las tablas se indica en el ON del JOIN
 Usaremos JOIN, como buena práctica, aunque hay algunos otros ejemplos 
 de composiciones internas resueltos con WHERE.
*/
SELECT e.cdemp, e.nombre, e.fecha_ingreso, d.nombre, d.ciudad
FROM empleado e
INNER JOIN departamento d ON e.cddep= d.cddep -- columnas por las que se combinana las tablas
WHERE e.salario > 1500; -- filtro de selección

/**** EJERCICIO 1. Listar el código y nombre de cada proyecto, 
y el código y nombre del departamento que lo dirige
con WHERE y con JOIN*/




-- 5)
/*código y nombre de cada empleado con el nombre de su jefe, 
para los empleados que tienen jefe.
*/

/* Observa que hay que combinar la tabla empleado con ella misma:
'empleado' como tabla de empleados y 'empleado' como tabla de jefes*/

-- con WHERE
SELECT e.cdemp, e.nombre, e.cdjefe, je.nombre
FROM empleado e, empleado je
WHERE e.cdjefe = je.cdemp;

-- con JOIN
SELECT e.cdemp, e.nombre, je.nombre as 'jefe'
FROM empleado e
INNER JOIN  empleado je ON e.cdjefe = je.cdemp;

-- 6) 
/*EJERCICIO RESUELTO:
código y nombre de los empleados junto a su salario 
y código de los proyectos en los que trabajan. 
Con JOIN y ordenado por empleado
*/

-- Hay que combinar las tablas empleado y trabaja
SELECT e.cdemp, e.nombre, e.salario, t.cdpro
FROM empleado e
JOIN  trabaja t ON e.cdemp= t.cdemp
ORDER BY e.cdemp;

-- 7) 
/*como la consulta anterior pero mostrando además  
 el nombre del proyecto)=> observa que se necesita además la tabla proyecto*/

SELECT e.cdemp, e.nombre, e.salario, t.cdpro, p.nombre 'proyecto'
FROM empleado e
INNER JOIN trabaja t ON e.cdemp= t.cdemp
INNER JOIN proyecto p ON t.cdpro= p.cdpro
ORDER BY e.cdemp;

/*Observa que es mucho más legible poner un alias a cada tabla, 
aún cuando no sea necesario,
y anteponer ese alias a cada columna referenciada*/

-- 8)
/*Código de empleado, su nombre, salario y código y nombre de
proyectos en los que trabaja, 
pero sólo para los empleados del departado de código '03'.
*/
-- con WHERE
SELECT e.cdemp, e.nombre, e.salario, t.cdpro, p.nombre, e.cddep
FROM empleado e, trabaja t, proyecto p
WHERE e.cdemp=t.cdemp AND t.cdpro= p.cdpro AND e.cddep='03';

/* Con JOIN, queda más claro el filtro de selección que realizamos, 
separando las condiciones que hacen referencia a la combinación de tablas (en JOIN)
de las condiciones del filtro en WHERE*/
SELECT e.cdemp, e.nombre, e.salario, t.cdpro, p.nombre, e.cddep
FROM empleado e
INNER JOIN trabaja t ON e.cdemp=t.cdemp 
INNER JOIN proyecto p ON t.cdpro=p.cdpro
WHERE  e.cddep='03';

-- 9)
/*Código y nombre de cada empleado, nombre de su departamento 
y nombres de proyectos en los que trabaja, ordenado por código de empleado*/

SELECT e.cdemp, e.nombre, d.nombre, d.cddep as 'Departamento', 
p.nombre as 'Proyecto'
FROM empleado e
INNER JOIN departamento d ON e.cddep=d.cddep
INNER JOIN trabaja t ON t.cdemp = e.cdemp
INNER JOIN proyecto p ON p.cdpro=t.cdpro
ORDER BY e.cdemp;


/****EJERCICIO CLASE: 
1.-La siguiente consulta ¿es correcta para resolver 9)?
-- observa que la combinación de tablas no es correcta
*/
SELECT e.cdemp, e.nombre, d.nombre as 'Departamento', 
p.nombre as 'Proyecto'
FROM empleado e
INNER JOIN departamento d ON e.cddep=d.cddep
INNER JOIN proyecto p ON p.cddep=d.cddep
ORDER BY e.cdemp;

/***EJERCICIO DE CLASE:
2.- Observa que el resultado de la consulta 9) son 9 filas. 
Observa que en la tabla TRABAJA hay 10 filas, lo que indica que se está trabajando 
en 10 proyectos, luego hay algún trabajador que no se ha listado. 

¿Por qué motivo no sale el empleado que falta?

¿Cómo conseguir que salga en el listado? 
con un JOIN Externo o OUTER JOIN 

 
/*** Composiciones EXTERNAS --- OUTER JOIN -- LEFT o RIGHT***/
/* Muestran también las filas en las que 
no hay coincidencia de valores en la columna de composición 
(columna por la que se combinan las tablas)
*/

/*LEFT [OUTER]JOIN: muestra tb las filas de la tabla de la IZQUIERDA del JOIN
sin coincidencia en el campo de composición
RIGHT [OUTER] JOIN: muestra tb las filas de la tabla de la DERECHA del JOIN
sin coincidencia en el campo de composición*/

-- 10)
/* ... si en la consulta 9) se desea listar a todos los empleados 
que trabajan en proyectos aunque no tengan departamento, sería:*/

SELECT e.cdemp, e.nombre, d.nombre, d.cddep as 'Departamento', 
p.nombre as 'Proyecto'
FROM empleado e
LEFT JOIN departamento d ON e.cddep=d.cddep
INNER JOIN trabaja t ON t.cdemp = e.cdemp
INNER JOIN proyecto p ON p.cdpro=t.cdpro
ORDER BY e.cdemp;

/*Observa que aunque de la tabla TRABAJA no se muestra ninguna información,
es necesario incluirla en la composición o combinación de tablas realizada con JOIN,
para obtener la información requerida */


/***** EJERCICIO 2. Listado con el código, nombre y fecha de alta de los empleados 
y nombre y ciudad de su departamento. Solo para los empleados con departamento y que se dieron de alta 
después del 1995  y durante el  segundo semestre del año. 
(Utiliza las funciones de fecha year() y month()).*/





/***** EJERCICIO 3. La consulta anterior, pero se deben mostrar también
lo empleados sin departamento.
*/



/***** EJERCICIO 4. Para los empleados que trabajan en proyectos, listado con el código,
nombre de cada empleado en el formato codigo-nombre, su fecha de ingreso, años de antigüedad y 
total de horas trabajadas en proyectos. 
Usa donde sea necesario las funciones de fecha datediff(), curdate(), 
la función truncate() y concat()
-- Intenta resolverlo primero sin calcular los años de antigüedad*/



-- 11)
/*Ejercicio resuelto: listado con los códigos y nombres 
de los distintos departamentos 
y el código, nombre y salario de sus empleados.
 Ten en cuenta que deben aparecer todos los departamentos 
 aunque no tengan asignados empleados
*/

SELECT d.cddep, d.nombre, e.cdemp, e.nombre, e.salario
FROM departamento d 
LEFT  JOIN  empleado e ON e.cddep=d.cddep;
-- se muestran todos los departamentos (tabla izquierda del JOIN)


/*observa que en el listado, los departamentos no relacionados (sin empleados), 
las columnas que hacen referencia a los empleados valen NULL
*/

-- 12)
/* La consulta anterior pero redactada con RIGHT JOIN*/

SELECT d.cddep, d.nombre, e.cdemp, e.nombre, e.salario
FROM empleado e
RIGHT JOIN  departamento d  ON e.cddep=d.cddep;
-- se muestran todos los departamentos (tabla derecha del JOIN)

-- 13)
/*Si queremos sustituir en el listado ese valor NULL por otro valor más descriptivo
se podría utilizar la función vista anteriormente IFNULL() o COALESCE()
*/

SELECT d.cddep, d.nombre, IFNULL(e.cdemp, 'sin empleados') AS 'empleado'
FROM departamento d
LEFT JOIN  empleado e ON e.cddep=d.cddep;

-- poniendo alias al nombre del departamento
SELECT d.cddep, d.nombre AS 'Departamento', IFNULL(e.cdemp, 'sin empleados') 'empleado'
FROM departamento d
LEFT JOIN  empleado e ON e.cddep=d.cddep;

-- con coalesce()
SELECT d.cddep, d.nombre, COALESCE(e.cdemp, 'sin empleados')
FROM departamento d
LEFT JOIN  empleado e ON e.cddep=d.cddep;

-- poniendo LEFT OUTER JOIN
SELECT d.cddep, d.nombre AS 'Departamento', IFNULL(e.cdemp, 'sin empleados') as 'Empleados'
FROM departamento d
LEFT OUTER JOIN  empleado e ON e.cddep=d.cddep;

-- 14) 
/*Nombre de todos los empleados y nombre de su departamento. 
Deben listarse todos los empleados, tengan o no departamento. 
Para los empleados sin departamento, debe aparecer **** donde corresponda. 
*/

SELECT e.nombre, ifnull(d.nombre, '****') departamento
FROM empleado e
LEFT JOIN departamento d ON e.cddep=d.cddep;

/****** EJERCICIO 5. Nombre de todos los empleados y nombre y ciudad de 
su departamento (pon alias descriptivos a los nombres). 
Si el empleado no tiene departamento, debe aparecer la cadena 
'****' en el lugar que proceda*/



-- 15)
/*El nombre de todos los empleados, su departamento y proyecto en el que trabajan, 
aunque el empleado no esté asignado a un departamento Y
aunque empleado no trabaje en proyecto*/
SELECT e.nombre as 'empleado' , IFNULL(d.nombre, '****')
as 'departamento', ifnull(p.nombre, 'sin proyecto') as 'proyecto'
FROM empleado e
LEFT JOIN departamento d ON e.cddep=d.cddep
LEFT JOIN trabaja t ON e.cdemp=t.cdemp
LEFT JOIN proyecto p ON p.cdpro=t.cdpro
ORDER BY e.nombre;

-- 16)
/*Código y nombre de cada empleado con el nombre de su jefe
En el listado deben aparecer todos los empleados aunque no tengan jefe.
*/

SELECT e.cdemp, e.nombre, IFNULL(je.nombre,'SIN JEFE')  as 'Jefe'
FROM empleado e
LEFT JOIN empleado je ON  e.cdjefe = je.cdemp;

-- 17)
/* código y nombre de los empleados 
que son jefes de otros*/

SELECT DISTINCT je.cdemp, je.nombre 
FROM empleado e
INNER JOIN empleado je ON e.cdjefe=je.cdemp;

-- 18)
/*Código y nombre de los empleados que son jefes de otros, pero mostrando también el total de 
subordinados que tienen.*/
-- Observa que hay que agrupar por jefe

SELECT je.cdemp, je.nombre, count(*) 'subordinados'
FROM empleado e
INNER JOIN empleado je ON e.cdjefe=je.cdemp
GROUP BY e.cdjefe;


/** EJERCICIO DE CLASE **, sobre la consulta 18) modificarla para que:
- solo se listen los jefes que ganan 2000 o más
- ordenar de mas a menos subordinados
- mostrar solo dos de los jewfes con más subordinados
*/
SELECT je.cdemp, je.nombre, count(*) 'subordinados'
FROM empleado e
INNER JOIN empleado je ON e.cdjefe=je.cdemp
where je.salario >=2000
group by e.cdjefe
having count(*) >=2
order by 3 desc
limit 2
;

/*** con USING ****/
/* Podemos utilizar USING cuando la columna de combinación tiene 
el mismo nombre en las tablas*/

-- 19)
/*Para cada empleado con departamento, su código, nombre, fecha de ingreso
y nombre de su departamento
*/
SELECT e.cdemp, e.nombre, e.fecha_ingreso, d.nombre as 'Departamento', d.ciudad
FROM empleado e
INNER JOIN departamento d USING (cddep);


/*** NATURAL JOIN ****/

-- 20)
/* Cuidado con NATURAL JOIN, pues combina las tablas por todas 
las columnas de igual nombre*/
SELECT e.cdemp, e.nombre, e.fecha_ingreso, d.nombre as 'Departamento', 
d.ciudad
FROM empleado e
NATURAL JOIN departamento d;

-- 21)
/*** CROSS JOIN ***/

/*Es el producto cartesiano*/
SELECT e.cdemp, e.nombre, e.fecha_ingreso, d.nombre as 'Departamento', d.ciudad
FROM empleado e
CROSS JOIN departamento d;

-- 22)
/*** LEFT OUTER JOIN ****/
-- Todos los empleados y su departamento
SELECT e.cdemp, e.nombre, e.fecha_ingreso, d.nombre as 'Departamento',  d.ciudad 
FROM empleado e 
LEFT JOIN departamento d ON e.cddep= d.cddep;

-- 23)
/*** RIGHT OUTER JOIN ****/
-- Todos los departamentos con sus empleados
SELECT  d.cddep, d.nombre as 'Departamento',d.ciudad, e.cdemp, e.nombre, e.fecha_ingreso  
FROM empleado e
RIGHT JOIN departamento d ON e.cddep= d.cddep;


/*¿Diferencia entre las dos composiciones externas anteriores?:
 la primera muestra todos los empleados, estén o no asociados a departamentos
 la segunda muestra todos los departamentos, tengan o no empleados asociados*/


-- 24)
/*** Si queremos que aparezcan todos los empleados y departamentos, 
se puede utilizar FULL OUTER**/

/*** FULL OUTER JOIN ****/
/* MySQL en la versión actual no implementa FULL OUTER*/
SELECT e.cdemp, e.nombre, e.fecha_ingreso, d.nombre as 'Departamento', d.ciudad
FROM empleado e
FULL OUTER JOIN departamento d;
-- observa que en MySQL da error


-- 25)
/*Se puede emular FULL OUTER con UNION*/

/** UNION ***/
-- Une el resultado de dos consultas. 
-- El encabezado de la consulta será el que se ponga en la primera de las consultas.
-- Es necesario que las consultas devuelvan el mismo número de itenms y en el mismo orden.
(SELECT e.cdemp, e.nombre, e.fecha_ingreso, d.nombre as 'Departamento',  d.ciudad
FROM empleado e
LEFT JOIN departamento d ON e.cddep= d.cddep
)
UNION
(SELECT e.cdemp, e.nombre,  e.fecha_ingreso, d.nombre as 'Departamento',  d.ciudad
FROM departamento d
LEFT JOIN empleado e ON e.cddep= d.cddep
);



/**** INTERSECT ***/
-- No implementada en MySQL, por ello da error
-- Obtiene los datos comunes de ambas consultas

-- 26)
/* Por ejemplo, si tenemos 2 tablas con datos de departamentos,
Podemos mostrar los datos de los departamentos que están en ambas tablas */
(SELECT cddep, nombre, ciudad
FROM departamento)
INTERSECT
(SELECT cddep, nombre, ciudad
FROM departamento2);

-- PARA ILUSTRAR el ejemplo
-- creamos la tabla departamento2 
-- se crea exactamente igual que departamento
CREATE TABLE departamento2 LIKE departamento;
-- insertamos tres filas iguales y una distinta;
INSERT INTO departamento2
(cddep,nombre,ciudad) VALUES ('01','Contabilidad-1','Almería'),
 ('02','Ventas','Sevilla'), ('03','I+D','Málaga'), 
 ('11', 'DISTINTO','Madrid');

/* En Mysql se puede emular el INTERSECT mediante INNER JOIN*/
SELECT cddep, nombre, ciudad
FROM departamento
INNER JOIN departamento2  USING (cddep, nombre, ciudad);

-- En este caso se podría emular también con NATURAL JOIN por denominarse igual las columnas
SELECT cddep, nombre, ciudad
FROM departamento
NATURAL JOIN departamento2;

/*** MINUS ***/
-- No implementada en MySQL, por ello da error
-- Obtiene los datos de una consulta que no están en la seguna consulta

-- 27)
/* Datos de departamentos que están en la tabla departamento y 
no están en la tabla departamento2*/

(SELECT cddep, nombre, ciudad
FROM departamento)
MINUS
(SELECT cddep, nombre, ciudad
FROM departamento2);

/*En MySQL lo podemos emular mediante subconsulta*/
SELECT  cddep, nombre, ciudad
FROM departamento
WHERE (cddep, nombre, ciudad) NOT IN
                    (SELECT cddep, nombre, ciudad FROM departamento2);
                    
SELECT cddep, nombre, ciudad
FROM departamento
WHERE cddep NOT IN (SELECT cddep FROM departamento2); 
  
    
  /****** SUBCONSULTAS *********/

/*¿Cómo obtener el nombre de los empleados con salario superior
 al salario medio?
 - Primero habrá que saber cual es el salario medio. 
 - Este dato nos lo proporcionará una subconsulta 
 */
  
 select cdemp, nombre, salario
 from empleado
 where salario >= 
 (select avg(salario) 
  from empleado);
  
  select avg(salario) 
  from empleado;
  
  /*SUBCONSULTA: consulta contenida en otra sentencia  SQL 
(contenedora).

1)Las subconsultas devuelven una tabla que puede consistir en: 
    - UN VALOR
    - VARIOS VALORES
       
2)El tipo de tabla que devuelven determina cómo deben
 utilizarse y  los operadores  que puede utilizar la sentencia 
 contenedora para  interactuar con la tabla devuelta por la subconsulta.
 
Subconsulta devuelve UN VALOR: Operador:>, <, <>, =, >=, <= 
Subconsulta que devuelve VARIOS VALORES: 
 - Operador IN (NOT IN) 
 - Predicado ALL/ANY combinado con operador relacional
 
3)Las tablas devueltas por las subconsultas son tablas 
 temporales, se  eliminan una vez que finaliza la sentencia 
 SQL contenedora.
 
4)Las subconsultas pueden aparecer tras  
 WHERE, HAVING, FROM, SELECT
 
5) Las subconsultas pueden ser:
- correlacionadas (suelen ir con EXIST)
- NO correlacionadas (subconsultas normales) 
 */
 
 /*Nos centramos en las que aparecen tras WHERE y No correlacionadas */
 
 /*Subconsultas No correlacionadas o Subconsultas Normales:
 - el sistema ejecuta primero la subconsulta (select más interna) 
 y después la select más externa.
 */
 
 -- 28)
 /*Datos de los departamentos que están en la misma ciudad que 
  el departamento de nombre 'Gerencia'
 */
 -- la subconsulta nos debe proporcionar la ciudad de 'Gerencia' 
 
 SELECT *
 FROM departamento
 WHERE ciudad = (SELECT ciudad FROM departamento WHERE nombre ='Gerencia');
 
 -- 29)
  /* Nombre y salario de los empleados con salario inferior 
  al de 'Esperanza Amarillo*/
  
 -- la subconsulta nos debe proporcionar el salario de 'Esperanza Amarillo' 
SELECT nombre, salario
FROM empleado
WHERE salario < 
     (SELECT salario FROM empleado     
     WHERE nombre = 'Esperanza Amarillo');
     
/* se puede ejecutar la consulta interna de forma separada*/
SELECT salario FROM empleado     
     WHERE nombre = 'Esperanza Amarillo';

-- 30)
/*Empleados que menos cobran */
-- Serán aquellos empleados con salario igual al salario mínimo
-- La subconsulta nos debe proporcinar el salario mínimo
SELECT nombre, salario
FROM empleado
WHERE salario = (SELECT MIN(salario) FROM empleado);

-- Esta consulta se puede plantear también con ALL (Todos)
-- Serán aquellos empleados cuyo salario es menor o igual que todos los salarios
 
SELECT nombre, salario
FROM empleado
WHERE salario <= ALL (SELECT salario FROM empleado); 

-- 31)
/*Empleados con salario superior al salario medio, 
mostrando también el nombre de su departamento y ciudad*/

-- la subconsulta nos debe proprocionar el salario medio
SELECT e.cdemp, e.nombre,d.nombre, d.ciudad
FROM empleado e
INNER JOIN departamento d ON e.cddep=d.cddep
WHERE salario >(select avg(salario ) from empleado);

select avg(salario) from empleado;


-- 32)
/* OTROS EJEMPLOS: Nombre,  salario y código de Jefe de los empleados 
que tienen como jefe un empleado del departamento “02”: */

-- la subconsulta nos debe proporcionar los empleados del departamento '02'
SELECT nombre, salario, cdjefe
FROM empleado
WHERE cdjefe IN (SELECT cdemp FROM empleado WHERE cddep='02');

/******EJERCICIO 6. Listado con el código y nombre de los empleados que no trabjan 
en proyectos.
*/


-- 33)
/* Lista de los empleados que cobran menos que
alguno del departamento “03”: */

/*con ANY (alguno)*/
-- la subconsulta nos debe proporcionar los salarios del departamento '03'
-- 
SELECT cdemp, nombre, salario
 FROM empleado
 WHERE salario < ANY 
      (SELECT salario FROM empleado WHERE cddep='03');
 
/* SUBCONSULTA*/
SELECT salario FROM empleado WHERE cddep='03';

/*otra forma: con MAX(): 
- si es menor que alguno, basta con que sea menor que el máximo*/
-- la subconsulta nos debe proporcionar el salario máximo o mayor 
SELECT cdemp, nombre,salario
 FROM empleado
 WHERE salario <  
      (SELECT MAX(salario) FROM empleado WHERE cddep='03');
 

/*SUBCONSULTA*/
SELECT MAX(salario) FROM empleado WHERE cddep='03';

-- 34)
/* Lista de los empleados que cobran MENOS que
los del departamento “03”: */

/*una forma: con ALL*/
-- el salario es menor que todos o cualquier salario del departamento '03'
SELECT cdemp, nombre, salario
 FROM empleado
 WHERE salario < ALL (SELECT salario FROM empleado WHERE cddep='03');

/*otra forma: MIN()*/ 
-- el salario es menor que el salario mínimo del departamento '03'     
SELECT cdemp, nombre, salario
 FROM empleado
 WHERE salario <  
      (SELECT MIN(salario) FROM empleado WHERE cddep='03');      
   
-- 35)
/* Lista de los empleados que cobran más que
alguno del departamento “03”: */

SELECT cdemp, nombre, salario
 FROM empleado
 WHERE salario > ANY 
      (SELECT salario FROM empleado WHERE cddep='03');
      
 /* o bien*/ 
 
SELECT cdemp, nombre, salario
 FROM empleado
 WHERE salario >  
      (SELECT MIN(salario) FROM empleado WHERE cddep='03');

-- 36)
/* Lista de los empleados que cobran más que
los del departamento “03”: */
SELECT cdemp, nombre, salario
 FROM empleado
 WHERE salario > ALL 
      (SELECT salario FROM empleado WHERE cddep='03');
 
/* SUBCONSULTA*/
 SELECT salario FROM empleado WHERE cddep='03';
 
 /* o bien*/
SELECT cdemp, nombre, salario
 FROM empleado
 WHERE salario >  
      (SELECT MAX(salario) FROM empleado WHERE cddep='03');
      


/*EJEMPLOS de subconsultas tras HAVING, FROM  y SELECT */

/*tras HAVING*/
-- 37)
/*empleados que han trabajado más horas en proyectos, 
que las dedicadas al 'AEE'*/
SELECT cdemp, SUM(nhoras) 
FROM trabaja
GROUP BY cdemp
HAVING SUM(nhoras)> (SELECT SUM(nhoras) 
                        FROM trabaja 
                        WHERE cdpro='AEE'); -- horas dedicadas al proyecto AEE


/*la subconsulta: total horas trabajadas en proyecto AEE*/
SELECT SUM(nhoras) 
FROM trabaja 
WHERE cdpro='AEE';

-- 38)
/*tras FROM: obligatorio poner alias a la tabla temporal 
tras FROM (tabla derivada)*/

/*Número medio de horas trabajadas en proyectos =
total horas de cada proyecto/número proyectos*/
SELECT AVG(suma_nhoras)
FROM (SELECT cdpro, SUM(nhoras) AS 'suma_nhoras' 
            FROM trabaja
            GROUP BY cdpro) AS htrabaja;

/*subconsulta: total de horas trabajadas en cada proyecto*/
SELECT cdpro, SUM(nhoras) as 'suma_nhoras' 
            FROM trabaja
            GROUP BY cdpro;

-- 39)
/*tras SELECT*/
/* Para cada empleado su código, nombre y nombre 
departamento*/
SELECT e.cdemp, e.nombre, (SELECT d.nombre
                                        FROM departamento d
                                        WHERE d.cddep=e.cddep) 
                               as departamento         
FROM empleado e;

-- seguro que se os ocurre hacerlo con JOIN
SELECT e.cdemp, e.nombre, d.nombre
FROM empleado e
LEFT JOIN departamento d ON d.cddep=e.cddep;

/*operador EXISTS*/
/*EXISTS: se evalúa a TRUE si la subconsulta  devuelve 
alguna fila. Como no importa el valor devuelto de la subconsulta tras 
el SELECT, ésta se puede optimizar poniendo un valor constante, como 1*/

-- 40)
/*Empleados que trabajan en departamentos de Almería*/
-- con EXIST y subconsulta correlacionada

/* SUBCONSULTA CORRELACIONADA: 
- subconsulta que en su criterio WHERE hace alusión 
a columnas de la tabla de la SELECT externa

-- El sistema no ejecuta primero la subconsulta y después la SELECT externa
-- sino que para cada fila de la tabla externa, busca si hay filas relacionadas 
-- según el criterio de la subconsulta o SELECT interna.
*/

SELECT e.nombre, e.cddep 
FROM empleado e
WHERE   EXISTS (SELECT 1 
                       FROM departamento d
                       WHERE d.ciudad='ALMERIA' AND
                       e.cddep= d.cddep);

/* Observa que en el WHERE de la subconsulta se hace referencia
a una columna de la tabla externa o select externa (e.cddep)*/

/**otra forma*/
-- con subconsulta normal
-- la subconsulta nos debe proporcionar los departamentos de Almería
SELECT nombre, cddep
FROM empleado 
WHERE cddep IN (SELECT cddep FROM departamento 
                  WHERE ciudad = 'Almeria');

-- con JOIN
SELECT e.nombre, e.cddep
FROM empleado e
INNER JOIN departamento d ON e.cddep=d.cddep
WHERE d.ciudad LIKE 'Almeria';


-- 41)
/**nombre de departamentos que dirigen proyectos*/
-- son los departamentos cuyo código aparece en la tabla 'proyectos'

/*con subconsulta normal*/
-- la subconsulta nos debe proprocionar 
-- los cddep que aparecen en la tabla proyecto
SELECT nombre
FROM departamento 
WHERE cddep IN (SELECT cddep FROM proyecto);

/*con subconsulta correlacionada*/
SELECT d.nombre
FROM departamento d
WHERE d.cddep  IN (SELECT p.cddep FROM proyecto p
                  WHERE d.cddep=p.cddep);
                  
/**otra forma: con JOIN*/
SELECT DISTINCT d.nombre
FROM departamento d
INNER JOIN proyecto p ON p.cddep=d.cddep;                 
                  
                  
                  

/****************************************************************/      
/*************** utilizar ÍNDICES para optimizar consultas**************/ 
 
 -- 42)
/*Mostrar los índices de la tabla empleado*/
SHOW INDEX FROM empleado;

-- 43)
/*EJEMPLO 1 
Crear un índice en la tabla empleado  basado en la columna salario del empleado: */
/* Nos puede interesar porque se realizan muchas consultas con criterio 
de búsqueda el salario del empleado*/

SELECT * 
FROM empleado
WHERE salario = 2000;

-- 44)
/* Podemos ver el plan de ejecución de la consulta, mediante EXPLAIN*/
EXPLAIN SELECT * 
FROM empleado
WHERE salario = 2000;

/* Observa el número de filas que debe consultar MySQL para obetner 
el resultado. 
A menor número de filas consultadas, más eficiente u óptima será la consulta*/

-- 45)
/* creamos un índice sobre la columna 'salario'*/
CREATE INDEX empleado_salario ON empleado (salario);
-- o con ALTER
ALTER TABLE empleado
ADD INDEX empleado_salario(salario);

-- 46)
/*vemos los índices de la tabla empleado*/
SHOW INDEX FROM empleado;

-- 47)
/* comprobamos otra vez el plan de ejecución de MySQL para la consulta anterior*/
EXPLAIN SELECT * 
FROM empleado
WHERE salario = 2000;

/*Observa que ahora MySQl tiene que consultar menos filas*/

-- 48)
/*En el ejemplo anterior, para eliminar el índice de nombre empleado_salario: */ 
DROP INDEX empleado_salario ON empleado;

/******* CREAR VISTAS PARA CONSULTAS COMPLEJAS *********/

/* En la empresa de nuestras prácticas se requiere a menudo una lista de 
nombres de proyecto y la suma de horas trabajadas en cada uno de ellos. 
Se podría crear una vista que resumiese esa consulta con un nombre descriptivo 
como “horas_trabajadas_por_proyecto”.*/

-- 49)
CREATE VIEW horas_trabajadas_por_proyecto (proyecto,horas_trabajadas) AS 
  SELECT p.nombre,SUM(t.nhoras) 
  FROM proyecto p 
  LEFT JOIN trabaja t   ON p.cdpro=t.cdpro 
  GROUP BY t.cdpro;

-- 50)
/*A partir de ese momento podemos consultar la vista como a cualquier tabla */

SELECT * 
FROM horas_trabajadas_por_proyecto;

/*Al ser tratada la VISTA como una tabla se podrían hacer consultas 
de cualquier tipo sobre la vista. 
*/

-- 51)
-- Por ejemplo, lista de proyectos con 50 o más horas trabajadas.
SELECT * FROM horas_trabajadas_por_proyecto 
WHERE horas_trabajadas >= 50;   

-- 52)
/*Se puede Modificar la vista anterior para que se muestre también 
el total de empleados que trabajan por proyecto*/
ALTER VIEW horas_trabajadas_por_proyecto ( proyecto,horas_trabajadas, emple) AS 
SELECT p.nombre,SUM(t.nhoras), COUNT(*)
FROM proyecto p 
LEFT JOIN trabaja t  ON p.cdpro=t.cdpro 
GROUP BY t.cdpro ;

-- 53)
/*CONSULTAMOS LA VISTA*/
SELECT * FROM horas_trabajadas_por_proyecto;
-- Datos de los proyectos en los que trabajan más de 2 empleados
select *
from horas_trabajadas_por_proyecto
where emple > 2
 ;
-- 54)
/* Para eliminar la vista anterior*/
DROP VIEW horas_trabajadas_por_proyecto;

/* Las tablas subyacentes no se verán afectadas por el borrado de la vista*/