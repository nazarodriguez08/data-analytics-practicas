-- ============================================================
-- PRE-ENTREGA 5: CONSULTAS CON JOINs PARA EL PROYECTO
-- Proyecto: RetailPro / TechStoress
-- Base de datos: Ventas_Tech_DB
-- Motor: SQL Server (SSMS)
-- Archivo: m5_consultas_joins.sql
-- ============================================================

USE Ventas_Tech_DB;
GO

-- ============================================================
-- CONSULTA 1: Vista base del proyecto (INNER JOIN)
-- Proposito: unir ventas, clientes, productos y categorias para
-- construir la tabla enriquecida que se utilizara en Power BI.
-- ============================================================
SELECT
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.email,
    c.ciudad AS region,
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p
    ON v.id_producto = p.id_producto
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta, v.id_venta;
-- Hallazgo: En los datos de ejemplo, 10 ventas suman $6.444.
-- La vista permite analizar la facturacion por ciudad y categoria.

-- ============================================================
-- CONSULTA 2: Clientes sin ventas (LEFT JOIN)
-- Proposito: identificar clientes registrados que aun no
-- realizaron compras para que el area de CRM los contacte.
-- ============================================================
SELECT
    c.nombre AS nombre_cliente,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
ORDER BY c.nombre;
-- Hallazgo: 0 de los 5 clientes estan sin compras en esta muestra.
-- CRM no detecta clientes sin primera compra en los datos cargados.

-- ============================================================
-- CONSULTA 3: Productos sin ventas (LEFT JOIN)
-- Proposito: detectar articulos sin movimientos de venta
-- para que el area de producto revise su rotacion.
-- ============================================================
SELECT
    p.nombre_producto,
    COALESCE(cat.nombre_categoria, 'Sin categoria') AS categoria,
    p.precio
FROM productos AS p
LEFT JOIN ventas AS v
    ON p.id_producto = v.id_producto
LEFT JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
WHERE v.id_venta IS NULL
ORDER BY p.nombre_producto;
-- Hallazgo: 0 de los 6 productos estan sin ventas en esta muestra.
-- Producto no identifica articulos sin movimiento en los datos cargados.

-- ============================================================
-- CONSULTA 4: Consolidado por canal/origen (UNION ALL)
-- Proposito: comparar las ventas de dos periodos del mes.
-- La columna canal se CREA como texto fijo en cada SELECT;
-- no existe como columna en la tabla ventas.
-- Los periodos no se superponen, asi cada venta se cuenta una vez.
-- ============================================================
SELECT
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT
        v.fecha_venta,
        v.cantidad * v.precio_unitario AS total,
        'Dias 1 al 10' AS canal
    FROM ventas AS v
    WHERE DAY(v.fecha_venta) BETWEEN 1 AND 10

    UNION ALL

    SELECT
        v.fecha_venta,
        v.cantidad * v.precio_unitario AS total,
        'Dias 11 en adelante' AS canal
    FROM ventas AS v
    WHERE DAY(v.fecha_venta) >= 11
) AS consolidado
GROUP BY canal
ORDER BY total_canal DESC;
-- Hallazgo: En marzo de 2024, los dias 1 al 10 suman $3.620,
-- frente a $2.824 desde el dia 11; el primer periodo vende $796 mas.
