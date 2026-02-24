-- -----------------------------------------------------
-- ELIMINAR Y CREAR BASE DE DATOS
-- -----------------------------------------------------

DROP SCHEMA IF EXISTS streamingdb;
CREATE SCHEMA IF NOT EXISTS streamingdb
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

USE streamingdb;

-- -----------------------------------------------------
-- TABLA PRODUCTORA
-- -----------------------------------------------------

CREATE TABLE productora (
  codigo_productora INT NOT NULL,
  nombre_productora VARCHAR(100) NOT NULL,
  premios TEXT,
  PRIMARY KEY (codigo_productora)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- TABLA CONTENIDO
-- -----------------------------------------------------

CREATE TABLE contenido (
  id_contenido INT NOT NULL,
  nombre_contenido VARCHAR(100) NOT NULL,
  fecha_salida DATE NOT NULL,
  tipo ENUM('Película','Serie') NOT NULL,
  genero VARCHAR(45) NOT NULL,
  codigo_productora INT NOT NULL,
  PRIMARY KEY (id_contenido),
  FOREIGN KEY (codigo_productora)
    REFERENCES productora(codigo_productora)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- TABLA SERIES
-- -----------------------------------------------------

CREATE TABLE series (
  id_contenido INT NOT NULL,
  PRIMARY KEY (id_contenido),
  FOREIGN KEY (id_contenido)
    REFERENCES contenido(id_contenido)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- TABLA PELICULAS
-- -----------------------------------------------------

CREATE TABLE peliculas (
  id_contenido INT NOT NULL,
  fecha_publicacion DATE NOT NULL,
  PRIMARY KEY (id_contenido),
  FOREIGN KEY (id_contenido)
    REFERENCES contenido(id_contenido)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- TABLA CAPITULOS
-- -----------------------------------------------------

CREATE TABLE capitulos (
  codigo_capitulo INT NOT NULL AUTO_INCREMENT,
  temporada INT NOT NULL,
  numero INT NOT NULL,
  duracion VARCHAR(45) NOT NULL,
  id_serie INT NOT NULL,
  PRIMARY KEY (codigo_capitulo),
  FOREIGN KEY (id_serie)
    REFERENCES series(id_contenido)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- TABLA METODO DE PAGO
-- -----------------------------------------------------

CREATE TABLE metodo_de_pago (
  codigo_pago INT NOT NULL,
  tipo_pago VARCHAR(50) NOT NULL,
  regularidad VARCHAR(50) NOT NULL,
  PRIMARY KEY (codigo_pago)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- TABLA USUARIO
-- -----------------------------------------------------

CREATE TABLE usuario (
  DNI VARCHAR(15) NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  apellidos VARCHAR(50) NOT NULL,
  correo VARCHAR(80) NOT NULL,
  telefono VARCHAR(20) NOT NULL,
  tipo VARCHAR(30) NOT NULL,
  PRIMARY KEY (DNI)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- TABLA PERFIL
-- -----------------------------------------------------

CREATE TABLE perfil (
  codigo_perfil INT NOT NULL,
  nick VARCHAR(50) NOT NULL,
  DNI_usuario VARCHAR(15) NOT NULL,
  PRIMARY KEY (codigo_perfil),
  FOREIGN KEY (DNI_usuario)
    REFERENCES usuario(DNI)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- TABLA COMPRA
-- -----------------------------------------------------

CREATE TABLE compra (
  id_contenido INT NOT NULL,
  codigo_pago INT NOT NULL,
  codigo_perfil INT NOT NULL,
  PRIMARY KEY (id_contenido, codigo_pago, codigo_perfil),
  FOREIGN KEY (id_contenido)
    REFERENCES contenido(id_contenido)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  FOREIGN KEY (codigo_pago)
    REFERENCES metodo_de_pago(codigo_pago)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  FOREIGN KEY (codigo_perfil)
    REFERENCES perfil(codigo_perfil)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- TABLA TRABAJADORES (RELACION REFLEXIVA)
-- -----------------------------------------------------
CREATE TABLE trabajadores (
  codigo_trabajador INT AUTO_INCREMENT,
  DNI VARCHAR(15) NOT NULL UNIQUE,
  nombre VARCHAR(50) NOT NULL,
  apellidos VARCHAR(50) NOT NULL,
  tipo_trabajador VARCHAR(50) NOT NULL,
  codigo_jefe INT,
  PRIMARY KEY (codigo_trabajador),
  FOREIGN KEY (codigo_jefe)
    REFERENCES trabajadores(codigo_trabajador)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- TABLA CONTRATA
-- -----------------------------------------------------

CREATE TABLE contrata (
  codigo_productora INT NOT NULL,
  DNI_trabajador VARCHAR(15) NOT NULL,
  PRIMARY KEY (codigo_productora, DNI_trabajador),
  FOREIGN KEY (codigo_productora)
    REFERENCES productora(codigo_productora)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  FOREIGN KEY (DNI_trabajador)
    REFERENCES trabajadores(DNI)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- TABLA RESEÑA (RELACION TERNARIA)
-- -----------------------------------------------------

CREATE TABLE reseña (
  codigo_perfil INT NOT NULL,
  id_contenido INT NOT NULL,
  fecha DATE NOT NULL,
  puntuacion INT NOT NULL,
  comentario TEXT,
  PRIMARY KEY (codigo_perfil, id_contenido),
  FOREIGN KEY (codigo_perfil)
    REFERENCES perfil(codigo_perfil)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (id_contenido)
    REFERENCES contenido(id_contenido)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- CREACION DE ROLES
-- -----------------------------------------------------

CREATE ROLE IF NOT EXISTS administrador;
CREATE ROLE IF NOT EXISTS cliente;
CREATE ROLE IF NOT EXISTS desarrollador;
CREATE ROLE IF NOT EXISTS soporte;

GRANT ALL PRIVILEGES ON streamingdb.* TO administrador;
GRANT SELECT ON streamingdb.* TO cliente;
GRANT SELECT, UPDATE, INSERT ON streamingdb.* TO desarrollador;
GRANT SELECT, UPDATE ON streamingdb.* TO soporte;

-- -----------------------------------------------------
-- CREACION DE USUARIOS
-- -----------------------------------------------------

CREATE USER IF NOT EXISTS 'administrador'@'localhost' IDENTIFIED BY 'ADM-123';
CREATE USER IF NOT EXISTS 'cliente'@'localhost' IDENTIFIED BY 'CLI-123';
CREATE USER IF NOT EXISTS 'desarrollador'@'localhost' IDENTIFIED BY 'dev123';
CREATE USER IF NOT EXISTS 'soporte'@'localhost' IDENTIFIED BY 'SOP-123';

GRANT administrador TO 'administrador'@'localhost';
GRANT cliente TO 'cliente'@'localhost';
GRANT desarrollador TO 'desarrollador'@'localhost';
GRANT soporte TO 'soporte'@'localhost';

SET DEFAULT ROLE ALL TO
'administrador'@'localhost',
'cliente'@'localhost',
'desarrollador'@'localhost',
'soporte'@'localhost';

SELECT user, host FROM mysql.user;
SELECT * FROM mysql.role_edges;

SHOW GRANTS FOR 'administrador'@'localhost';
SHOW GRANTS FOR 'cliente'@'localhost';
SHOW GRANTS FOR 'desarrollador'@'localhost';
SHOW GRANTS FOR 'soporte'@'localhost';

-- -----------------------------------------------------
-- INSERT SIMPLE PRODUCTORA
-- -----------------------------------------------------

INSERT INTO productora VALUES
(1, 'Warner Bros', 'Oscar 2020'),
(2, 'Netflix Studios', 'Emmy 2022'),
(3, 'Universal Pictures', 'Globo de Oro 2019');

-- -----------------------------------------------------
-- INSERT SIMPLE CONTENIDO
-- -----------------------------------------------------

INSERT INTO contenido VALUES
(100, 'Inception', '2010-07-16', 'Película', 'Ciencia Ficción', 1),
(101, 'Stranger Things', '2016-07-15', 'Serie', 'Terror', 2),
(102, 'Jurassic Park', '1993-06-11', 'Película', 'Aventura', 3),
(103, 'The Witcher', '2019-12-20', 'Serie', 'Fantasía', 2);

-- -----------------------------------------------------
-- CAPITULOS
-- -----------------------------------------------------

INSERT INTO capitulos (temporada, numero, duracion, id_serie) VALUES
(1, 1, '50 min', 101),
(1, 2, '48 min', 101),
(1, 1, '60 min', 103),
(1, 2, '58 min', 103);

-- -----------------------------------------------------
-- METODO DE PAGO
-- -----------------------------------------------------

INSERT INTO metodo_de_pago VALUES
(1, 'Tarjeta', 'Mensual'),
(2, 'PayPal', 'Anual'),
(3, 'Transferencia', 'Mensual');

-- -----------------------------------------------------
-- INSERT SIMPLE USUARIO
-- -----------------------------------------------------

INSERT INTO usuario VALUES
('12345678A', 'Juan', 'Pérez', 'juan@gmail.com', '600111222', 'Premium'),
('87654321B', 'Ana', 'López', 'ana@gmail.com', '600333444', 'Estándar'),
('11223344C', 'Carlos', 'Martín', 'carlos@gmail.com', '600555666', 'Básico');

-- -----------------------------------------------------
-- INSERT SIMPLE PERFIL
-- -----------------------------------------------------

INSERT INTO perfil VALUES
(1, 'JuanKids', '12345678A'),
(2, 'JuanMain', '12345678A'),
(3, 'AnaPerfil', '87654321B'),
(4, 'CarlosPerfil', '11223344C');

-- -----------------------------------------------------
-- COMPRA
-- -----------------------------------------------------

INSERT INTO compra VALUES
(100, 1, 2),
(101, 2, 3),
(102, 1, 4),
(103, 3, 1);

-- -----------------------------------------------------
-- INSERT SIMPLE TRABAJADORES
-- -----------------------------------------------------

INSERT INTO trabajadores 
(codigo_trabajador, DNI, nombre, apellidos, tipo_trabajador, codigo_jefe) VALUES
(1, '90000001A', 'Laura', 'Gómez', 'Directora', NULL),
(2, '90000002B', 'Miguel', 'Santos', 'Productor', 1),
(3, '90000003C', 'Elena', 'Ruiz', 'Guionista', 2),
(4, '90000004D', 'David', 'Navarro', 'Actor', 2);

-- -----------------------------------------------------
-- INSERT SIMPLE CONTRATA
-- -----------------------------------------------------

INSERT INTO contrata VALUES
(1, '90000001A'),
(1, '90000002B'),
(2, '90000003C'),
(3, '90000004D');

-- -----------------------------------------------------
-- INSERT SIMPLE RESEÑA
-- -----------------------------------------------------

INSERT INTO reseña VALUES
(2, 100, '2024-01-10', 9, 'Excelente película'),
(3, 101, '2024-02-05', 8, 'Muy entretenida'),
(4, 102, '2024-03-12', 10, 'Un clásico'),
(1, 103, '2024-04-20', 7, 'Buena pero algo lenta');
SELECT * FROM reseña;

-- ------------------------------------------------------
-- 1.3 Múltiple. Insertar varios registros a la vez
-- ------------------------------------------------------
INSERT INTO contrata (codigo_productora) SELECT codigo FROM productora;
-- ------------------------------------------------------
-- 2.1 UPDATE Simple. Actualizar un solo registro
-- ------------------------------------------------------
UPDATE reseña SET puntuacion = 9 WHERE comentario = 'Muy entretenida'; -- Usando columna comentario al no haber una PK 
-- ------------------------------------------------------
-- 3.1 DELETE Simple. Elimiinar un registro específico
-- ------------------------------------------------------
INSERT INTO usuario VALUES ('00000000A', NULL, NULL, NULL, NULL);
DELETE FROM usuario WHERE DNI = '00000000A';
-- ------------------------------------------------------------------------------------
-- 3.5 DELETE en Cascada Simulado. Eliminar registros respetando integridad referencial
-- ------------------------------------------------------------------------------------
DELETE FROM reseña WHERE codigo_perfil = 1;
DELETE FROM perfil WHERE codigo_perfil = 1;

-- -----------------------------------------------------
-- 1.2 INSERT con Subconsulta. Usar SELECT dentro de INSERT (miguel)
-- -----------------------------------------------------

insert into series
select id_contenido
from contenido
where tipo = "serie";

-- -----------------------------------------------------
-- 1.6: INSERT a partir de un SELECT (miguel)
-- -----------------------------------------------------

insert into peliculas
select c.id_contenido, c.fecha_salida
from contenido c
where tipo = (select distinct tipo
				from contenido
                where tipo = "pelicula");
                
-- -----------------------------------------------------
-- 2.4: UPDATE con JOIN Múltiple, a varias tablas (miguel)
-- -----------------------------------------------------
                
UPDATE usuario u
JOIN perfil p ON u.DNI = p.DNI_usuario
SET u.tipo = 'VIP'
WHERE p.nick = 'JuanMain';

-- -----------------------------------------------------
-- 3.4: DELETE Condicional con lógica compleja (miguel)
-- -----------------------------------------------------

DELETE u
FROM usuario u
JOIN perfil p ON u.DNI = p.DNI_usuario
JOIN compra c ON p.codigo_perfil = c.codigo_perfil
JOIN metodo_de_pago m ON c.codigo_pago = m.codigo_pago
WHERE m.tipo_pago = 'PayPal';
