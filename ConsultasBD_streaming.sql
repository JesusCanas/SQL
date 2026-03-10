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

-- ----------------------------------------
-- 13. LEFT JOIN
-- ----------------------------------------

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

-- -----------------------------------------------------
-- 30: Subconsultas Anidadas
-- Mostrar los perfiles cuyo usuario sea de tipo Básico.
-- -----------------------------------------------------
SELECT * FROM perfil WHERE DNI_usuario IN (SELECT DNI FROM usuario WHERE nombre NOT IN (SELECT nombre FROM usuario WHERE tipo = 'Básico'));
