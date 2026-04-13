USE streamingdb;
-- ----------------------------------------------------------
-- Un procedimiento de consulta con parámetros de filtrado
-- ----------------------------------------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS filtrar_resenias;
CREATE PROCEDURE filtrar_resenias(IN id_cont INT, IN min_puntuacion TINYINT, IN max_puntuacion TINYINT)
BEGIN
	SELECT * FROM reseña WHERE id_contenido = id_cont && puntuacion >= min_puntuacion && puntuacion <= max_puntuacion;
END//
DELIMITER ;
CALL filtrar_resenias(100, 8, 10);
