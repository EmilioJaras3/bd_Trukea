CREATE DATABASE bd_trukea;

use bd_trukea;

CREATE TABLE ciudades (
  id_ciudad INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
);

CREATE TABLE categorias (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  categoria VARCHAR(100) NOT NULL,
  descripcion_categoria TEXT
);

CREATE TABLE calidad (
  id_calidad INT AUTO_INCREMENT PRIMARY KEY,
  nivel_calidad VARCHAR(50) NOT NULL,
  descripcion_calidad TEXT
);

CREATE TABLE zona_segura (
  id_zona INT AUTO_INCREMENT PRIMARY KEY,
  nombre_zona VARCHAR(100),
  direccion TEXT
);

CREATE TABLE usuarios (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  apellido_paterno VARCHAR(50) NOT NULL,
  apellido_materno VARCHAR(50),
  fecha_nacimiento DATE,
  correo VARCHAR(255) UNIQUE NOT NULL,
  clave VARCHAR(255) NOT NULL,
  id_ciudad INT,
  FOREIGN KEY (id_ciudad) REFERENCES ciudades(id_ciudad)
);

CREATE TABLE productos (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  nombre_producto VARCHAR(100) NOT NULL,
  descripcion_producto TEXT,
  valor_estimado INT,
  id_calidad INT,
  id_categoria INT,
  FOREIGN KEY (id_calidad) REFERENCES calidad(id_calidad),
  FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE publicaciones (
  id_publicacion INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT,
  id_producto INT,
  fecha_publicacion DATE,
  fecha_cierre DATE,
  id_ciudad INT,
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
  FOREIGN KEY (id_ciudad) REFERENCES ciudades(id_ciudad)
);

CREATE TABLE publicacion_imagenes (
  id_imagen INT AUTO_INCREMENT PRIMARY KEY,
  id_publicacion INT,
  imagen_url VARCHAR(255),
  FOREIGN KEY (id_publicacion) REFERENCES publicaciones(id_publicacion)
);

CREATE TABLE publicacion_estatus_historial (
  id_historial INT AUTO_INCREMENT PRIMARY KEY,
  id_publicacion INT,
  status ENUM('Pendiente', 'Aceptado', 'Cancelado', 'Finalizado') DEFAULT 'Pendiente',
  fecha_modificacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  modificado_por INT,
  FOREIGN KEY (id_publicacion) REFERENCES publicaciones(id_publicacion),
  FOREIGN KEY (modificado_por) REFERENCES usuarios(id_usuario)
);

CREATE TABLE historial_intercambios (
  id_intercambio INT AUTO_INCREMENT PRIMARY KEY,
  id_publicacion INT,
  id_usuario_1 INT,
  id_usuario_2 INT,
  FOREIGN KEY (id_publicacion) REFERENCES publicaciones(id_publicacion),
  FOREIGN KEY (id_usuario_1) REFERENCES usuarios(id_usuario),
  FOREIGN KEY (id_usuario_2) REFERENCES usuarios(id_usuario)
);

CREATE TABLE calificaciones (
  id_calificacion INT AUTO_INCREMENT PRIMARY KEY,
  id_intercambio INT,
  id_usuario_calificador INT,
  id_usuario_calificado INT,
  puntaje TINYINT,
  fecha_calificacion DATE,
  FOREIGN KEY (id_intercambio) REFERENCES historial_intercambios(id_intercambio),
  FOREIGN KEY (id_usuario_calificador) REFERENCES usuarios(id_usuario),
  FOREIGN KEY (id_usuario_calificado) REFERENCES usuarios(id_usuario)
);

CREATE TABLE zona_segura_horario (
  id_horario INT AUTO_INCREMENT PRIMARY KEY,
  id_zona INT,
  dia_de_semana ENUM('Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'),
  hora_apertura TIME,
  hora_cierre TIME,
  FOREIGN KEY (id_zona) REFERENCES zona_segura(id_zona)
);

CREATE TABLE solicitud_intercambio (
  id_solicitud INT AUTO_INCREMENT PRIMARY KEY,
  id_publicacion INT,
  id_usuario_solicitante INT,
  id_producto_ofrecido INT,
  status ENUM('Pendiente', 'Aceptado', 'Rechazado') DEFAULT 'Pendiente',
  fecha_solicitud DATE,
  FOREIGN KEY (id_publicacion) REFERENCES publicaciones(id_publicacion),
  FOREIGN KEY (id_usuario_solicitante) REFERENCES usuarios(id_usuario),
  FOREIGN KEY (id_producto_ofrecido) REFERENCES productos(id_producto)
);