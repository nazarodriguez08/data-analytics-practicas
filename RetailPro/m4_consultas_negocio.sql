Proyecto RetailPro - Prácticas SQL
-- Pre-entrega 4: Consultas SQL de negocio
-- Proyecto: RetailPro
-- Base de datos: Ventas_Tech_DB
-- Motor: SQL Server

USE Ventas_Tech_DB;
GO

-- ============================================================
-- CONSULTA 1: Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio por mes.
-- ============================================================
SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    CAST(SUM(cantidad * precio_unitario) * 1.0 / NULLIF(COUNT(*), 0)
        AS DECIMAL(18, 2)) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- ============================================================
-- CONSULTA 2: Ranking de los 5 productos con mayor facturacion
-- ============================================================
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC, id_producto ASC;

-- ============================================================
-- CONSULTA 3: Clientes recurrentes (mas de un pedido)
-- ============================================================
SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC, total_gastado DESC;

-- ============================================================
-- CONSULTA 4: Productos por encima o debajo del promedio
-- El promedio se calcula sobre los totales por producto,
-- no sobre las filas individuales de ventas.
-- ============================================================
WITH facturacion_por_producto AS (
    SELECT
        id_producto,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY id_producto
)
SELECT
    id_producto,
    total_facturado,
    CASE
        WHEN total_facturado > (
            SELECT AVG(CAST(total_facturado AS DECIMAL(18, 2)))
            FROM facturacion_por_producto
        ) THEN 'Por encima'
        WHEN total_facturado < (
            SELECT AVG(CAST(total_facturado AS DECIMAL(18, 2)))
            FROM facturacion_por_producto
        ) THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS comparacion_promedio
FROM facturacion_por_producto
ORDER BY total_facturado DESC, id_producto ASC;

-- HALLAZGOS DE NEGOCIO

-- 1. En marzo de 2024, RetailPro registro
-- 10 pedidos, con una facturacion total de
-- $6444 y un ticket promedio de $644.40.

-- 2. El producto con ID 1 fue el que mas
-- facturo, generando $3600 con 3 unidades
-- vendidas. Representa el 55.87% del total.

-- 3. Los cinco clientes realizaron 2 pedidos
-- cada uno. El cliente con ID 1 fue el que
-- mas gasto, con un total de $2640.
