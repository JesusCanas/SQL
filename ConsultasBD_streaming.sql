USE streamingdb;
-- --------------------------------------
-- 1 Consultas Simples
-- --------------------------------------

SELECT  nombre_productora FROM productora WHERE premios IS NOT NULL;
SELECT * FROM contenido WHERE id_contenido =102;

-- ----------------------------------------
-- 3.Operadores Lógicos
-- ----------------------------------------
SELECT * FROM usuario WHERE tipo = 'Básico' AND DNI = '11223344C';

-- --------------------------------------
-- 5. GROUP BY Simple
-- --------------------------------------
SELECT codigo_productora, nombre_productora FROM productora GROUP BY 1;

-- ----------------------------------------
-- 7.DISTINCT
-- ----------------------------------------
SELECT DISTINCT codigo_productora FROM contrata;

-- ----------------------------------------
-- 9. SubConsulta Simple CON IN 
-- ---------------------------------------- 
SELECT nombre_contenido, tipo FROM contenido WHERE id_contenido
IN ( SELECT p.id_contenido FROM peliculas p);

-- ----------------------------------------
-- 11.INNER JOIN Básico (dos tablas)
-- ----------------------------------------
SELECT * FROM perfil p INNER JOIN usuario u ON u.DNI = p.DNI_usuario;

-- ----------------------------------------
-- 13. LEFT JOIN
-- ----------------------------------------

-- ----------------------------------------
-- 15.SELF JOIN (tabla consigo misma)
-- ----------------------------------------
SELECT * FROM trabajadores t INNER JOIN trabajadores j ON  t.DNI_jefe = j.DNI WHERE j.DNI_jefe IS NULL;

-- ----------------------------------------
-- 19.JOIN con Múltiples Condiciones
-- ----------------------------------------
SELECT * FROM perfil p INNER JOIN usuario u ON u.DNI = p.DNI_usuario WHERE u.DNI = '12345678A' AND p.nick = 'JuanKids';

-- ----------------------------------------
-- 23.Subconsulta con IN
-- ----------------------------------------
SELECT * FROM perfil WHERE DNI_usuario IN (SELECT DNI FROM usuario WHERE nombre = 'Juan');

-- ----------------------------------------
-- 27.Subconsulta en FROM (Tabla Derivada)
-- ----------------------------------------
SELECT * FROM contrata c INNER JOIN (SELECT * FROM productora WHERE codigo_productora = 1) p; 

-- -----------------------------------------------------
-- 2: Búsqueda con LIKE (miguel)
-- -----------------------------------------------------
select *from usuario
where nombre like '%a%';

-- -----------------------------------------------------
-- 6: HAVING (miguel)
-- -----------------------------------------------------
select * from usuario
having DNI >= '12345678A';

-- -----------------------------------------------------
-- 10: BETWEEN (miguel)
-- -----------------------------------------------------
select * from reseña
where fecha between '2024-01-01' and '2024-04-13';

-- -----------------------------------------------------
-- 14: RIGHT JOIN (miguel)
-- -----------------------------------------------------
select * from reseña r right join perfil p
on r.codigo_perfil = p.codigo_perfil
where p.nick = 'JuanKids';

-- -----------------------------------------------------
-- 18: JOIN con Subconsultas (miguel)
-- -----------------------------------------------------
SELECT p.nick,
       (SELECT COUNT(*)
         FROM reseña r
         WHERE r.codigo_perfil = p.codigo_perfil)  AS total_reseñas
FROM perfil p;

-- -----------------------------------------------------
-- 22: Subconsulta en WHERE (miguel)
-- -----------------------------------------------------
select * from perfil
where DNI_usuario = (select DNI from usuario
					where nombre = 'Juan');

-- -----------------------------------------------------
-- 26: Subconsulta con NOT EXISTS (miguel)
-- -----------------------------------------------------
SELECT *
FROM contenido c
WHERE NOT EXISTS (
    SELECT r.id_contenido
    FROM reseña r
    WHERE r.id_contenido = c.id_contenido
);

-- -----------------------------------------------------
-- 30: Subconsultas Anidadas (miguel)
-- -----------------------------------------------------
SELECT nombre_contenido,
       (SELECT AVG(puntuacion)
        FROM reseña r
        WHERE r.id_contenido = c.id_contenido) AS puntuacion_media
FROM contenido c;
