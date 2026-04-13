# SQL
## EJERCICIOS
- 1.1: INSERT Simple. Un solo registro. (jesus)
- 1.2: INSERT con Subconsulta. Usar SELECT dentro de INSERT (miguel)
- 1.3: INSERT Múltiple. Insertar varios registros a la vez (aron)
- 1.4: INSERT con Valores Calculados (funciones) (stephano)
- 1.5: INSERT con Validación. Insertar solo si se cumple una condición (jesus)
- 1.6: INSERT a partir de un SELECT (miguel)
- 2.1: UPDATE Simple. Actualizar un solo registro (aron)
- 2.2: UPDATE con Cálculo (stephano)
- 2.3: UPDATE Basado en Subconsulta (jesus)
- 2.4: UPDATE con JOIN Múltiple, a varias tablas (miguel)
- 3.1: DELETE Simple. Elimiinar un registro específico (aron)
- 3.2: DELETE con Subconsulta (stephano)
- 3.3: DELETE con JOIN (jesus)
- 3.4: DELETE Condicional con lógica compleja (miguel)
- 3.5: DELETE en Cascada Simulado. Eliminar registros respetando integridad referencial (aron)
- 4.1: Transacción Completa. : Operación atómica con múltiples DML (stephano)
### Consejos:
- Verifica integridad referencial: Antes de eliminar, comprueba las relaciones
- Antes de ejecutar DELETE/UPDATE: Haz siempre un SELECT primero para verificar qué registros
afectarás
- Usa transacciones: Para operaciones complejas o múltiples DML
- Haz backups: Antes de operaciones destructivas
  
#### EJERCICIOS CONSULTAS (OTRO SQL):
- 1: Selección Simple con riltros (jesus)
- 2: Búsqueda con LIKE (miguel)
- 3: Operadores Lógicos (aron)
- 4: Agregación Básica (stephano)
- 5: GROUP BY Simple (jesus)
- 6: HAVING (miguel)
- 7: DISTINCT (aron)
- 8: Gestión de NULL (stephano)
- 9: Subconsulta Simple con IN (jesus)
- 10: BETWEEN                                                                                                               (miguel)
- 11: INNER JOIN Básico (dos tablas) (aron)
- 12: INNER JOIN Múltiple (tres tablas) (stephano)
- 13: LEFT JOIN (jesus)
- 14: RIGHT JOIN (miguel)
- 15: SELF JOIN (tabla consigo misma) (aron)
- 16: JOIN con Agregación (stephano)
- 17: JOIN con Condiciones Complejas (jesus)
- 18: JOIN con Subconsultas (miguel)
- 19: JOIN con Múltiples Condiciones (aron)
- 20: Unión de Resultados (UNION) (stephano)
- 21: LEFT JOIN con Filtro Complejo (jesus)
- 22: Subconsulta en WHERE (miguel)
- 23: Subconsulta con IN (aron)
- 24: Subconsulta con NOT IN (stephano)
- 25: Subconsulta con EXISTS (jesus)
- 26: Subconsulta con NOT EXISTS (miguel)
- 27: Subconsulta en FROM (Tabla Derivada) (aron)
- 28: Subconsulta con ALL (stephano)
- 29: Subconsulta con ANY/SOME (jesus)
- 30: Subconsultas Anidadas (miguel)
  # PROGRAMAR EN BASE DE DATOS
  1. Procedimientos almacenados
Implementar al menos 3 procedimientos almacenados que cubran operaciones habituales de su base de
datos:
- Un procedimiento de inserción con validación de datos (jesus)
- Un procedimiento de consulta con parámetros de filtrado  (aron)
- Un procedimiento de actualización o eliminación con control de errores  (stephano)
2. Funciones
Implementar al menos 2 funciones que devuelvan un valor calculado a partir de los datos, por ejemplo:
- Calcular un total, un promedio o un descuento  (miguel)
- Comprobar si un valor cumple una condición de negocio  (jesus)
3. Triggers
Implementar al menos 3 triggers que automaticen acciones sobre la base de datos:
Un trigger de tipo INSERT para registrar o validar inserciones  (aron)
Un trigger de tipo UPDATE para controlar modificaciones  (stephano)
Un trigger de tipo DELETE para proteger o registrar eliminaciones (miguel)
Control de errores
En todos los elementos anteriores se debe aplicar:
- Uso de SIGNAL SQLSTATE para lanzar errores personalizados (jesus)
- Validación de datos antes de operar (valores nulos, rangos, existencia de registros)  (aron)
- Manejo de excepciones con DECLARE ... HANDLER (stephano)
Tabla de log 
Como requisito transversal, se debe crear una tabla de auditoría donde los triggers registren
automáticamente las operaciones más relevantes, incluyendo: 
• La tabla afectada
• El tipo de operación
• Una descripción del cambio
• La fecha y hora de la transacción


