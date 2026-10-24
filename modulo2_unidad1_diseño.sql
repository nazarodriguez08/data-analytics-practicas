CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,        -- Identificador numérico del cliente
    nombre VARCHAR(100),   -- Nombre de hasta 100 caracteres
    perfil_bio VARCHAR(MAX), -- Biografía o notas largas
    fecha_registro DATE    -- Fecha de registro del cliente
);

CREATE TABLE productos (
    id_producto INT PRIMARY KEY, -- Identificador único del producto
    descripcion VARCHAR(255), -- Texto de hasta 255 caracteres
    precio DECIMAL(10,2), -- Precio con dos cifras decimales
    esta_activo BIT -- 1 significa activo y 0 inactivo
);