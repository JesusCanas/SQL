USE streamingdb;
-- --------------------------------------
-- 1 Consultas Simples
-- --------------------------------------

SELECT  nombre_productora FROM productora WHERE premios IS NOT NULL;
SELECT * FROM contenido WHERE id_contenido =102;

-- --------------------------------------
-- 5. GROUP BY Simple
-- --------------------------------------
SELECT codigo_productora, nombre_productora FROM productora GROUP BY 1;

-- ----------------------------------------
-- 9. SubConsulta Simple CON IN 
-- ---------------------------------------- 
SELECT nombre_contenido, tipo FROM contenido WHERE id_contenido
IN ( SELECT p.id_contenido FROM peliculas p);

-- ----------------------------------------
-- 13. LEFT JOIN
-- ----------------------------------------
