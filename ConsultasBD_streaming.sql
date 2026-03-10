USE streamingdb;
-- --------------------------------------
-- 1 Consultas Simples
-- Sacar el nombre de las productoras que tengan algún premio.
-- Sacar la información del contenido con id 102.
-- --------------------------------------

SELECT  nombre_productora FROM productora WHERE premios IS NOT NULL;
SELECT * FROM contenido WHERE id_contenido =102;

-- -----------------------------------------------------
-- 2: Búsqueda con LIKE
-- Sacar la informacion de los usuarios cuyo nombre contenga una "a".
-- -----------------------------------------------------
select *from usuario
where nombre like '%a%';

-- ----------------------------------------
-- 3.Operadores Lógicos
-- Sacar el usuario cuyo tipo de cuenta sea basico y DNI sea "11223344C".
-- ----------------------------------------
SELECT * FROM usuario WHERE tipo = 'Básico' AND DNI = '11223344C';

-- ------------------------------------------------
-- 4: Agregación Básica (stephano)
-- Muestra cuantos contenidos hay en la plataforma.
-- ------------------------------------------------
SELECT COUNT(*) AS total_contenidos
FROM contenido;

-- --------------------------------------
-- 5. GROUP BY Simple
-- Mostrar cuanto contenido hay de cada género.
-- --------------------------------------
SELECT genero, COUNT(*) FROM contenido GROUP BY 1;

-- -----------------------------------------------------
-- 6: HAVING
-- Mostrar cuanto contenido hay de cada género que tenga 2 o mas contenidos.
-- -----------------------------------------------------
SELECT genero, COUNT(*) AS num_cont FROM contenido GROUP BY 1 HAVING num_cont >= 2;

-- ----------------------------------------
-- 7.DISTINCT
-- Mostrar todos los codigos de productora distintos que han contratado a algun trabajador.
-- ----------------------------------------
SELECT DISTINCT codigo_productora FROM contrata;

-- -----------------------------------------------------
-- 8: Gestión de NULL (stephano)
-- Muestra los trabajadores que no tienen jefe asignado.
-- -----------------------------------------------------
SELECT COUNT(*) AS total_contenidos
FROM contenido;

-- ----------------------------------------
-- 9. SubConsulta Simple CON IN 
-- Mostrar el nombre y tipo de contenido de las peliculas.
-- ---------------------------------------- 
SELECT nombre_contenido, tipo FROM contenido WHERE id_contenido
IN ( SELECT p.id_contenido FROM peliculas p);


-- -----------------------------------------------------
-- 10: BETWEEN
-- Mostrar las reseñas hechas entre las fechas '2024-01-01' y '2024-04-13'.
-- -----------------------------------------------------
select * from reseña
where fecha between '2024-01-01' and '2024-04-13';

-- ----------------------------------------
-- 11.INNER JOIN Básico (dos tablas)
-- Mostrar toda la información de los usuarios junto con sus perfiles.
-- ----------------------------------------
SELECT * FROM perfil p INNER JOIN usuario u ON u.DNI = p.DNI_usuario;

-- ------------------------------------------------------------------------------
-- 12: INNER JOIN Múltiple (tres tablas) (stephano)
-- Muestra el nick del perfil, el contenido comprado y el tipo de pago utilizado.
-- ------------------------------------------------------------------------------
SELECT p.nick, c.nombre_contenido, m.tipo_pago
FROM compra co
INNER JOIN perfil p ON co.codigo_perfil = p.codigo_perfil
INNER JOIN contenido c ON co.id_contenido = c.id_contenido
INNER JOIN metodo_de_pago m ON co.codigo_pago = m.codigo_pago;

-- ----------------------------------------
-- 13. LEFT JOINç
-- Mostrar las reseñas, sean de algun perfil o no.
-- ----------------------------------------
SELECT * FROM reseña r LEFT JOIN perfil p 
ON r.codigo_perfil = p.codigo_perfil;

-- -----------------------------------------------------
-- 14: RIGHT JOIN
-- Mostrar todos los perfiles, junto con las resseñas que han hecho, mostrar tambien los perfiles sin reseñas.
-- -----------------------------------------------------
select * from reseña r right join perfil p
on r.codigo_perfil = p.codigo_perfil;

-- ----------------------------------------
-- 15.SELF JOIN (tabla consigo misma)
-- Consultar los jefes cuyo DNI es vacío.
-- ----------------------------------------
SELECT * FROM trabajadores t INNER JOIN trabajadores j ON  t.DNI_jefe = j.DNI WHERE j.DNI_jefe IS NULL;

-- ------------------------------------------------
-- 16: JOIN con Agregación (stephano)
-- Cuenta cuántos contenidos tiene cada productora.
-- ------------------------------------------------
SELECT pr.nombre_productora, COUNT(c.id_contenido) AS total_contenidos
FROM productora pr
JOIN contenido c ON pr.codigo_productora = c.codigo_productora
GROUP BY pr.nombre_productora;

-- ----------------------------------------
-- 17. JOIN con Condiciones Complejas
-- Muestra los contenidos que tengan una puntuacion 
-- entre 8 y 10.
-- ----------------------------------------
SELECT c.* FROM contenido c INNER JOIN reseña r
ON r.id_contenido = c.id_contenido WHERE r.puntuacion BETWEEN 8 AND 10;

-- -----------------------------------------------------
-- 18: JOIN con Subconsultas
-- Consultar las reseñas que ha hecho un usuario, mostrando su nick.
-- -----------------------------------------------------
SELECT p.nick,
       (SELECT COUNT(*)
         FROM reseña r
         WHERE r.codigo_perfil = p.codigo_perfil)  AS total_reseñas
FROM perfil p;

-- ----------------------------------------
-- 19.JOIN con Múltiples Condiciones
-- Mostrar el perfil del usuario JuanKids.
-- ----------------------------------------
SELECT * FROM perfil p INNER JOIN usuario u ON u.DNI = p.DNI_usuario WHERE u.DNI = '12345678A' AND p.nick = 'JuanKids';

-- ------------------------------------------------------------
-- 20: Unión de Resultados (UNION) (stephano)
-- Muestra los nombres de películas y series en una sola lista.
-- ------------------------------------------------------------
SELECT nombre_contenido
FROM contenido
WHERE tipo = 'Película'
UNION
SELECT nombre_contenido
FROM contenido
WHERE tipo = 'Serie';

-- ----------------------------------------
-- 21.LEFT JOIN CON filtro complejo
-- pide el nombre del contenido y su puntuacion
-- de la tabla reseña que su puntuacion sea
-- mayor que 8 o nulo.
-- ----------------------------------------
SELECT c.nombre_contenido, r.puntuacion
FROM contenido c
LEFT JOIN reseña r 
ON c.id_contenido = r.id_contenido
WHERE r.puntuacion > 8 OR r.puntuacion IS NULL;

-- -----------------------------------------------------
-- 22: Subconsulta en WHERE
-- Mostrar el perfil de todos los usuarios con nombre Juan.
-- -----------------------------------------------------
select * from perfil
where DNI_usuario = (select DNI from usuario
					where nombre = 'Juan');

-- ----------------------------------------
-- 23.Subconsulta con IN
-- Mostrar el perfil de todos los usuarios con nombre Juan (versión con IN).
-- ----------------------------------------
SELECT * FROM perfil WHERE DNI_usuario IN (SELECT DNI FROM usuario WHERE nombre = 'Juan');

-- -------------------------------------------------------------------
-- 24: Subconsulta con NOT IN (stephano)
-- Muestra los contenidos que no han sido comprados por ningún perfil.
-- -------------------------------------------------------------------
SELECT nombre_contenido
FROM contenido
WHERE id_contenido NOT IN (
    SELECT id_contenido
    FROM compra
);

-- ---------------------------------------
-- 25.SUBCONSULTAS con EXIST.  
-- Esta subconsulta te muestra todo de la 
-- tabla del metodo de pago que existan en 
-- la tabla compra
-- ----------------------------------------
SELECT *
FROM metodo_de_pago m
WHERE EXISTS (
    SELECT c.codigo_pago
    FROM compra c
    WHERE c.codigo_pago = m.codigo_pago
);

-- -----------------------------------------------------
-- 26: Subconsulta con NOT EXISTS
-- Mostrar el contenido el cual no tiene ninguna reseña.
-- -----------------------------------------------------
SELECT *
FROM contenido c
WHERE NOT EXISTS (
    SELECT r.id_contenido
    FROM reseña r
    WHERE r.id_contenido = c.id_contenido
);

-- --------------------------------------------------
-- 27.Subconsulta en FROM (Tabla Derivada)
-- Mostrar los contratos de la productora con id = 1.
-- --------------------------------------------------
SELECT * FROM contrata c INNER JOIN (SELECT * FROM productora WHERE codigo_productora = 1) p; 

-- -------------------------------------------------------------------------------------------------------
-- 28: Subconsulta con ALL (stephano)
-- Muestra los contenidos cuya fecha de salida es posterior a todas las fechas de salida de las películas.
-- -------------------------------------------------------------------------------------------------------
SELECT nombre_contenido, fecha_salida
FROM contenido
WHERE fecha_salida > ALL (
    SELECT fecha_salida
    FROM contenido
    WHERE tipo = 'Película'
);

-- ---------------------------------------
-- 29.SUBCONSULTAS con ANY/SOME. 
-- Buscando la pelicula o serie que salio exactamente el 2010-07-16
-- ----------------------------------------
SELECT nombre_contenido, fecha_salida FROM contenido
WHERE fecha_salida = ANY (
    SELECT fecha_publicacion FROM peliculas 
    WHERE fecha_publicacion = '2010-07-16'); 

-- -----------------------------------------------------
-- 30: Subconsultas Anidadas
-- Mostrar los perfiles cuyo usuario sea de tipo Básico.
-- -----------------------------------------------------
SELECT * FROM perfil WHERE DNI_usuario IN (SELECT DNI FROM usuario WHERE nombre NOT IN (SELECT nombre FROM usuario WHERE tipo = 'Básico'));
