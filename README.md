# Sistema de Reservas - Polideportivo Martos

Aplicación web desarrollada con tecnología Java JSP (JavaServer Pages) y Jakarta Servlets para la gestión de reservas de pistas deportivas y comunicación interna entre usuarios.

## 🛠️ Tecnologías Utilizadas

* **Backend:** Java 23, Jakarta Servlet API 6.1.0, JSP
* **Base de Datos:** MySQL 8.0
* **Seguridad:** Cifrado de contraseñas con jBCrypt (Blowfish)
* **Despliegue local:** Docker & Docker Compose
* **Gestor de dependencias:** Maven
* **Diseño:** HTML5, CSS3 vanilla (diseño premium y adaptable)

## 🚀 Funcionalidades Principales

1. **Gestión de Usuarios:** Registro seguro, inicio de sesión robusto y control de sesiones HTTP.
2. **Edición de Perfil:** Modificación de datos personales (nombre, correo, teléfono) y cambio seguro de contraseña.
3. **Cuadrante de Disponibilidad:** Visualización interactiva de la ocupación de pistas en la semana actual con validaciones de fechas.
4. **Sistema de Reservas:** Creación de reservas para pistas libres y posibilidad de cancelar reservas propias desde el panel del usuario.
5. **Chat Interno:** Mensajería directa entre usuarios. Permite ponerse en contacto de forma ágil haciendo clic sobre el nombre del usuario que reservó una pista.

## 📦 Requisitos Previos

* Docker y Docker Compose instalados.
* Servidor de aplicaciones compatible con Jakarta Servlet 6.0+ (por ejemplo, GlassFish 7.0+ o Apache Tomcat 10.1+).
* Java Development Kit (JDK) 23 instalado (opcional, para compilación manual).

## 🛠️ Instrucciones de Despliegue

### 1. Iniciar la Base de Datos con Docker
El proyecto incluye una receta de Docker Compose que levanta un contenedor MySQL 8.0 y carga automáticamente el esquema inicial de tablas.

Desde la raíz del proyecto, ejecuta:
```bash
docker-compose up -d
```

Esto creará la base de datos `polideportivo` en el puerto `3306` con el usuario `root` y la contraseña `root`.

### 2. Estructura de la Base de Datos
El script `sql/init.sql` creará las siguientes tablas con sus correspondientes restricciones de clave foránea y unicidad:
* `usuarios`: Almacena el identificador, credenciales (hash de contraseña), nombre, email y teléfono.
* `reservas`: Gestiona las reservas por pista, fecha y hora, asegurando la imposibilidad de solapamiento.
* `mensajes`: Permite la comunicación por chat, guardando remitente, destinatario, contenido y fecha de envío.

### 3. Compilación y Despliegue del Servidor de Aplicaciones
1. Importa el proyecto en tu IDE preferido (como IntelliJ IDEA) utilizando el archivo `pom.xml`.
2. Compila el empaquetado `.war` a través del ciclo de vida de Maven:
   ```bash
   mvn clean package
   ```
3. Despliega el archivo `.war` generado en tu servidor de aplicaciones.
4. Accede a la aplicación a través del navegador (habitualmente en `http://localhost:8080/polideportivo-jsp`).
