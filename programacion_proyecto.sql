USE streamingdb;
-- ---------------------------------------------------------------
-- Un procedimiento de consulta con parámetros de filtrado
-- ---------------------------------------------------------------
DELIMITER //

DROP PROCEDURE IF EXISTS filtrar_resenias;

CREATE PROCEDURE filtrar_resenias(IN id_cont INT, IN min_puntuacion TINYINT, IN max_puntuacion TINYINT)
BEGIN
    IF id_cont IS NULL OR min_puntuacion IS NULL OR max_puntuacion IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se permiten valores NULL';
    END IF;

    IF min_puntuacion > max_puntuacion THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El mínimo no puede ser mayor que el máximo';
    END IF;

    IF min_puntuacion < 0 OR max_puntuacion > 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Las puntuaciones deben estar entre 0 y 10';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM contenido WHERE id = id_cont) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El contenido no existe';
    END IF;

    SELECT *
    FROM reseña
    WHERE id_contenido = id_cont
      AND puntuacion >= min_puntuacion
      AND puntuacion <= max_puntuacion;

END//

DELIMITER ;

-- ---------------------------------------------------------------
-- Un trigger de tipo INSERT para registrar o validar inserciones
-- ---------------------------------------------------------------
DELIMITER //
CREATE TRIGGER validar_dni
BEFORE INSERT ON usuario
FOR EACH ROW
BEGIN
    IF NEW.dni NOT REGEXP '^[0-9]{8}[A-Za-z]$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Formato de DNI inválido';
    END IF;
END//

DELIMITER ;
