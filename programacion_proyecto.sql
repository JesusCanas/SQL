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
-- Funcion de negocio
-- ----------------------------------------------------------------
DELIMITER //

CREATE FUNCTION fn_validar_rentabilidad(p_id_contenido INT) 
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE v_resultado VARCHAR(20);
    DECLARE v_genero VARCHAR(45);
    DECLARE v_premios VARCHAR(255);

    SELECT c.genero, p.premios INTO v_genero, v_premios
    FROM contenido c
    JOIN productora p ON c.codigo_productora = p.codigo_productora
    WHERE c.id_contenido = p_id_contenido;

    IF v_premios IS NOT NULL AND (v_genero = 'Ciencia Ficción' OR v_genero = 'Terror') THEN
        SET v_resultado = 'ALTA RENTABILIDAD';
    ELSEIF v_premios IS NOT NULL THEN
        SET v_resultado = 'POTENCIAL';
    ELSE
        SET v_resultado = 'ESTÁNDAR';
    END IF;

    RETURN v_resultado;
END //

DELIMITER ;
SELECT nombre_contenido, genero, fn_validar_rentabilidad(id_contenido) AS analisis
FROM contenido;
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

-- ---------------------------------------------------------------
-- Funcion que devuelve un promedio de puntuaciones de un contenido
-- ---------------------------------------------------------------
DROP FUNCTION IF EXISTS promedio_puntuacion;
DELIMITER //
CREATE FUNCTION promedio_puntuacion(contenido_id INT)
RETURNS DECIMAL(4,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(4,2); -- declaramos la variable que devolveremos
	DECLARE existe INT; -- declaramos una variable de error

    -- Handler de error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error al calcular el promedio';
    END;

    -- Validar si es null
    IF contenido_id IS NULL THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El id_contenido no puede ser NULL';
    END IF;

    -- Validar que exista el contenido usando un select con id_contenido
    SELECT COUNT(*) INTO existe
    FROM contenido
    WHERE id_contenido = contenido_id;

    IF existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El contenido no existe';
    END IF;
    
    -- select para realiza el promedio de puntuaciones solo si 
    -- las comprobaciones anteriores resultaron bien
    SELECT AVG(puntuacion)
    INTO promedio
    FROM reseña
    WHERE id_contenido = contenido_id;

    RETURN promedio; -- devuelve el promedio
END //
DELIMITER ;

SELECT promedio_puntuacion(101);
