USE streamingdb;
-- ---------------------------------------------------------------
-- Un procedimiento de comprobacion de validacion de datos 
-- ---------------------------------------------------------------
DELIMITER //

CREATE PROCEDURE pr_insertar_usuario_jesus(
    IN p_dni VARCHAR(15),
    IN p_nombre VARCHAR(50),
    IN p_apellidos VARCHAR(50),
    IN p_correo VARCHAR(80),
    IN p_telefono VARCHAR(20),
    IN p_tipo ENUM('Básico', 'Estándar', 'Premium'),
    OUT p_mensaje VARCHAR(100)
)
BEGIN
    IF p_dni IS NULL OR p_dni = '' OR p_nombre IS NULL OR p_nombre = '' THEN
        SET p_mensaje = 'Error: Campos obligatorios vacios';
    ELSE
        INSERT INTO usuario (DNI, nombre, apellidos, correo, telefono, tipo)
        VALUES (p_dni, p_nombre, p_apellidos, p_correo, p_telefono, p_tipo);
        
        INSERT INTO log (tabla, operacion, descripcion, fecha)
        VALUES ('usuario', 'INSERT', CONCAT('Registro: ', p_nombre), NOW());
        
        SET p_mensaje = 'usuario registrado con exito';
    END IF;
    
    SELECT p_mensaje AS Resultado;
END //

DELIMITER ;
CALL pr_insertar_usuario_jesus('99887766Z', 'Jesus', 'García', 'jesus@mail.com', '600111222', 'Premium', @resultado); -- Para probar un registro exitoso
SELECT @resultado;

-- Para probar el error (dejando el nombre vacío):
CALL pr_insertar_usuario_jesus('11223344K', '', 'Sanz', 'test@mail.com', '600000000', 'Básico', @resultado); -- Para probar que pasa si poner usuario en blaco
SELECT @resultado;
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

    IF NOT EXISTS (SELECT 1 FROM contenido WHERE id_contenido = id_cont) THEN
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
CALL filtrar_resenias(1, 8, 10); -- Error de reseña no encontrada
CALL filtrar_resenias(100, 11, 10); -- Error de minimo > maximo
CALL filtrar_resenias(100, -1, 11); -- Error de fuera de rango
CALL filtrar_resenias(100, 8, 10); -- Llamada correcta

-- ---------------------------------------------------------------
-- Un trigger de tipo INSERT para registrar o validar inserciones
-- ---------------------------------------------------------------
DROP TRIGGER IF EXISTS validar_usuario
DELIMITER //
CREATE TRIGGER validar_usuario
BEFORE INSERT ON usuario
FOR EACH ROW
BEGIN
    IF NEW.dni NOT REGEXP '^[0-9]{8}[A-Za-z]$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Formato de DNI inválido';
    END IF;
    IF NEW.telefono NOT REGEXP '^[0-9]{9}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Formato de teléfono inválido';
    END IF;
END//

DELIMITER ;
INSERT INTO usuario VALUES('1234', 'Estefanía', 'Dolores', 'estefania@gmail.com', '606060606', 'Básico'); -- Error de formato incorrecto de DNI
INSERT INTO usuario VALUES('12345678T', 'Estefanía', 'Dolores', 'estefania@gmail.com', '606066', 'Básico'); -- Error de formato incorrecto de numero de telefono
INSERT INTO usuario VALUES('12345678T', 'Estefanía', 'Dolores', 'estefania@gmail.com', '606060606', 'Básico'); -- Insert correcto
