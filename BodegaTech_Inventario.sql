-- ==========================================
-- BodegaTech - Script de Inventario
-- Autor: Nazarena Rodriguez
-- Fecha: 10/11/2026
-- ==========================================

USE BodegaTech;
GO

-- ==========================================
-- SECCION DDL
-- ==========================================

-- Eliminar la tabla si ya existe
DROP TABLE IF EXISTS inventario;
GO

-- Crear la tabla inventario
CREATE TABLE inventario (

    -- INT identifica cada producto con un numero entero unico
    id_producto INT PRIMARY KEY,

    -- VARCHAR almacena nombres de hasta 100 caracteres
    nombre_producto VARCHAR(100),

    categoria VARCHAR(50),

    -- DECIMAL permite almacenar precios con dos decimales
    precio_unitario DECIMAL(10,2),

    -- INT almacena cantidades enteras de productos
    stock_actual INT,

    stock_minimo INT,

    -- DATE almacena la fecha de ingreso
    fecha_ingreso DATE,

    -- BIT utiliza 1 para activo y 0 para inactivo
    activo BIT
);
GO

-- ==========================================
-- SECCION DML
-- ==========================================

-- Insertar los 10 productos iniciales

INSERT INTO inventario (
    id_producto,
    nombre_producto,
    categoria,
    precio_unitario,
    stock_actual,
    stock_minimo,
    fecha_ingreso,
    activo
)
VALUES
(1, 'Laptop Pro 15', 'Computación', 1200.00, 15, 3, '2024-01-10', 1),
(2, 'Mouse Inalámbrico', 'Accesorios', 28.00, 80, 10, '2024-01-10', 1),
(3, 'Monitor 4K 27"', 'Computación', 450.00, 12, 2, '2024-01-15', 1),
(4, 'Teclado Mecánico', 'Accesorios', 95.00, 40, 5, '2024-01-15', 1),
(5, 'Laptop Basic 14', 'Computación', 650.00, 20, 3, '2024-02-01', 1),
(6, 'Auriculares BT Pro', 'Audio', 120.00, 35, 5, '2024-02-01', 1),
(7, 'Hub USB-C 7 puertos', 'Accesorios', 45.00, 60, 10, '2024-02-10', 1),
(8, 'Webcam HD 1080p', 'Accesorios', 85.00, 25, 5, '2024-02-10', 1),
(9, 'SSD Externo 1TB', 'Almacenamiento', 130.00, 18, 3, '2024-03-01', 1),
(10, 'Parlante Bluetooth', 'Audio', 60.00, 45, 8, '2024-03-01', 1);

-- ==========================================
-- ACTUALIZAR VENTAS DEL DIA
-- ==========================================

-- Venta de 3 unidades de Laptop Pro
UPDATE inventario
SET stock_actual = stock_actual - 3
WHERE id_producto = 1;

-- Venta de 12 unidades de Mouse
UPDATE inventario
SET stock_actual = stock_actual - 12
WHERE id_producto = 2;

-- Venta de 5 unidades de Auriculares
UPDATE inventario
SET stock_actual = stock_actual - 5
WHERE id_producto = 6;

-- ==========================================
-- PRODUCTO DESCONTINUADO
-- ==========================================

-- Desactivar la Webcam HD
UPDATE inventario
SET activo = 0
WHERE id_producto = 8;

-- ==========================================
-- VALIDACION FINAL
-- ==========================================

-- Mostrar todos los productos
SELECT * FROM inventario;