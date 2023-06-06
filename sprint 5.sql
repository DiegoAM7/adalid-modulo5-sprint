-- Se crea la base de datos telovendo
CREATE DATABASE telovendo;

-- Se crea el usuario admin con contraseña admin123
CREATE USER admin WITH PASSWORD 'admin123';
GRANT ALL PRIVILEGES ON DATABASE telovendo TO telovendo;

-- Crear la tabla de proveedores con los datos necesarios
CREATE TABLE proveedores (
  proveedor_id SERIAL PRIMARY KEY,
  nombre_rep_legal VARCHAR(50),
  nombre_corporativo VARCHAR(100),
  categoria VARCHAR(50),
  correo_factura VARCHAR(100)
);

-- Crear la tabla de contactos de los proveedores
CREATE TABLE contacto_proveedores (
  contacto_id SERIAL PRIMARY KEY,
  proveedor_id INT NOT NULL,
	nombre_contacto VARCHAR(50),
  numero_telefono VARCHAR(15),

  FOREIGN KEY (proveedor_id) REFERENCES proveedores (proveedor_id)
);

-- Insertar 5 proveedores
INSERT INTO proveedores (nombre_rep_legal, nombre_corporativo, categoria, correo_factura) VALUES
('John Smith', 'Electronics Inc.' , 'Electrónicos', 'johnsmith@electronics.com'),
('Emma Davis', 'Tech Solutions', 'Electrónicos', 'emmadavis@techsolutions.com'),
('Michael Johnson', 'Gadget World', 'Electrónicos', 'michaeljohnson@gadgetworld.com'),
('Sophia Wilson', 'Innovative Tech', 'Electrónicos', 'sophiawilson@innovativetech.com'),
('Robert Anderson', 'Global Electronics', 'Electrónicos', 'robertanderson@globalelectronics.com');

-- Insertar los teléfonos de los proveedores
INSERT INTO contacto_proveedores (proveedor_id, nombre_contacto, numero_telefono) VALUES
(1, 'Alex Johnson', '5551234567'),
(1, 'Daniel Brown', '5559876543'),
(2, 'Jennifer Thompson', '5552345678'),
(2, 'David Lee', '5558765432'),
(3, 'Jessica Davis', '5553456789'),
(3, 'Richard Miller', '5557654321'),
(4, 'Robert Wilson', '5554567890'),
(4, 'Michelle Garcia', '5556543210'),
(5, 'William Martinez', '5555678901'),
(5, 'Mary Robinson', '5554321098');

-- Crear la tabla de clientes
CREATE TABLE clientes (
  cliente_id SERIAL PRIMARY KEY,
  nombre VARCHAR(50),
  apellido VARCHAR(50),
  direccion VARCHAR(100)
);

-- Insertar 5 clientes de ejemplo
INSERT INTO clientes (nombre, apellido, direccion) VALUES
('Juan', 'García', 'Calle Principal 123'),	
('María', 'López', 'Avenida Central 456'),
('Carlos', 'Martínez', 'Plaza Mayor 789'),
('Laura', 'Rodríguez', 'Paseo del Sol 987'),
('Pedro', 'Hernández', 'Callejón del Parque 654');

-- Crear la tabla de productos
CREATE TABLE productos (
  producto_id SERIAL PRIMARY KEY,
  nombre VARCHAR(100),
  categoria VARCHAR(50),
  proveedor_id INT NOT NULL,
  precio_clp BIGINT,
  stock INT,
  color VARCHAR(50),

  FOREIGN KEY (proveedor_id) REFERENCES proveedores (proveedor_id)
);

-- Insertar 10 productos de ejemplo
INSERT INTO productos (nombre, categoria, proveedor_id, precio_clp, stock, color) VALUES
('Televisor LED', 'Electrónicos', 1, 499990, 20, 'Negro'),
('Smartphone', 'Electrónicos', 2, 899990, 30, 'Plateado'),
('Laptop', 'Electrónicos', 3, 1299990, 25, 'Gris'),
('Cámara DSLR', 'Electrónicos', 4, 899990, 10, 'Negro'),
('Auriculares inalámbricos', 'Electrónicos', 5, 149990, 40, 'Blanco'),
('Reloj inteligente', 'Electrónicos', 1, 199990, 15, 'Negro'),
('Altavoz Bluetooth', 'Electrónicos', 2, 79990, 25, 'Rojo'),
('Tablet', 'Electrónicos', 3, 399990, 15, 'Azul'),
('Impresora multifuncional', 'Electrónicos', 4, 299990, 12, 'Blanco'),
('Consola de videojuegos', 'Electrónicos', 5, 499990, 20, 'Negro');


-- Cuál es la categoría de productos que más se repite:
SELECT categoria, COUNT(*) AS repeticiones
FROM productos
GROUP BY categoria
ORDER BY repeticiones DESC
LIMIT 1;

-- Cuáles son los productos con mayor stock:
SELECT *
FROM productos
WHERE stock >= (SELECT MAX(stock) FROM productos);

SELECT *
FROM productos
WHERE stock >= (SELECT AVG(stock) FROM productos)
ORDER BY stock DESC;

-- Qué color de producto es más común en nuestra tienda:
SELECT color, COUNT(*) AS repeticiones
FROM productos
GROUP BY color
ORDER BY repeticiones DESC
LIMIT 1;

-- Cual o cuales son los proveedores con menor stock de productos:
SELECT p.nombre_corporativo, pr.stock
FROM proveedores p
JOIN productos pr ON p.proveedor_id = pr.proveedor_id
WHERE pr.stock = (SELECT MIN(stock) FROM productos);

-- Para cambiar la categoría de productos más popular por 'Electrónica y computación':
UPDATE productos
SET categoria = 'Electrónica y computación'
WHERE categoria = (SELECT categoria FROM productos GROUP BY categoria ORDER BY COUNT(*) DESC LIMIT 1); 