CREATE TABLE IF NOT EXISTS usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  nombre VARCHAR(100),
  email VARCHAR(100),
  telefono VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS reservas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT NOT NULL,
  pista VARCHAR(50) NOT NULL,
  fecha DATE NOT NULL,
  hora INT NOT NULL,
  UNIQUE KEY unica_reserva (pista, fecha, hora),
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS mensajes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  remitente_id INT NOT NULL,
  destinatario_id INT NOT NULL,
  contenido TEXT NOT NULL,
  fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (remitente_id) REFERENCES usuarios(id) ON DELETE CASCADE,
  FOREIGN KEY (destinatario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);