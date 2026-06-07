# Product API

## Tabla de Contenido

- [Descripcion del Proyecto](#descripcion-del-proyecto)
- [Stack Tecnologico](#stack-tecnologico)
- [Arquitectura](#arquitectura)
- [Esquema de Base de Datos](#esquema-de-base-de-datos)
- [Endpoints Disponibles](#endpoints-disponibles)
- [Instalacion y Ejecucion](#instalacion-y-ejecucion)

---

## 1. Descripcion del Proyecto

API REST construida con Spring Boot para la gestion de productos y clientes. Expone operaciones CRUD sobre las entidades `Producto` y `Cliente` persistidas en MySQL, implementando validacion de datos y utilizando JPA/Hibernate como capa de acceso a datos.

---

## 2. Stack Tecnologico

| Tecnologia | Version |
|---|---|
| Java | 17.0.12 |
| Spring Boot | 3.5.0 |
| Spring Data JPA | 3.5.0 |
| Spring Validation | 3.5.0 |
| Hibernate ORM | 6.6.15 |
| MySQL | 8.4 |
| Maven | 3.9.9 |

| Apache Tomcat | Embebido en Spring Boot |
| XAMPP | 8.2.12-0 |

---

## 3. Arquitectura por Capas

Proyecto implementando una arquitectura en capas:

```mermaid
graph TD
    subgraph Cliente
        HTTP[HTTP Client]
    end

    subgraph Spring Boot
        Controller[Controller Layer]
        Service[Service Layer]
        Repository[Repository Layer]
        Entity[Entity Layer]
    end

    subgraph Database
        MySQL[(MySQL 8.4)]
    end

    HTTP -->|Request| Controller
    Controller --> Service
    Service --> Repository
    Repository -->|JPA/Hibernate| MySQL
    Repository --> Entity
    Entity -->|Mapeo ORM| MySQL
```

**Capas:**

- **Controller** — Maneja las peticiones HTTP y delega al service. `ProductoController`, `ClienteController`.
- **Service** — Contiene la logica de negocio y validaciones. `ProductoService`, `ClienteService`.
- **Repository** — Capa de acceso a datos, extiende JpaRepository. `ProductoRepository`, `ClienteRepository`.
- **Entity** — Modelo del dominio mapeando las tablas de la base de datos. `Producto`, `Cliente`.

### Diagrama del flujo de una peticion POST

```mermaid
sequenceDiagram
    participant C as Cliente HTTP
    participant Ctrl as Controller
    participant Svc as Service
    participant Repo as Repository
    participant DB as MySQL

    C->>Ctrl: POST /api/productos (JSON)
    Ctrl->>Ctrl: @Valid valida el cuerpo
    Ctrl->>Svc: crearProducto(producto)
    Svc->>Repo: existsByNombreIgnoreCase(nombre)
    Repo-->>Svc: false (no duplicado)
    Svc->>Repo: save(producto)
    Repo->>DB: INSERT INTO productos
    DB-->>Repo: fila insertada
    Repo-->>Svc: Producto con id
    Svc-->>Ctrl: Producto creado
    Ctrl-->>C: 201 Created (JSON)
```

---

## 4. Esquema de Base de Datos

```mermaid
erDiagram
    productos {
        BIGINT id PK "AUTO_INCREMENT"
        VARCHAR(100) nombre "NOT NULL"
        VARCHAR(255) descripcion "NOT NULL"
        DECIMAL precio "NOT NULL"
        INT stock "NOT NULL"
    }
    clientes {
        BIGINT id PK "AUTO_INCREMENT"
        VARCHAR(100) nombre "NOT NULL"
        VARCHAR(100) apellido "NOT NULL"
        VARCHAR(150) correo "NOT NULL"
        VARCHAR(20) telefono "NOT NULL"
        VARCHAR(255) direccion "NOT NULL"
    }
```

---

## 5. Endpoints Disponibles

**URL Base:** `http://localhost:8081/api/productos`

| Metodo | Ruta | Descripcion |
|---|---|---|
| `GET` | `/ping` | Health check del servicio |
| `GET` | `/` | Listar todos los productos |
| `GET` | `/{id}` | Buscar producto por ID |
| `POST` | `/` | Crear un nuevo producto |
| `PUT` | `/{id}` | Actualizar un producto existente |
| `DELETE` | `/{id}` | Eliminar un producto |

**Ejemplo de cuerpo para POST/PUT:**

```json
{
  "nombre": "Monitor LED",
  "descripcion": "Monitor de 24 pulgadas",
  "precio": 129.99,
  "stock": 10
}
```

### Clientes

**URL Base:** `http://localhost:8081/api/clientes`

| Metodo | Ruta | Descripcion |
|---|---|---|
| `GET` | `/` | Listar todos los clientes |
| `GET` | `/{id}` | Buscar cliente por ID |
| `POST` | `/` | Crear un nuevo cliente |
| `PUT` | `/{id}` | Actualizar un cliente existente |
| `DELETE` | `/{id}` | Eliminar un cliente |

**Ejemplo de cuerpo para POST/PUT:**

```json
{
  "nombre": "Carlos",
  "apellido": "Gomez",
  "correo": "carlos.gomez@email.com",
  "telefono": "0991234567",
  "direccion": "Av. Amazonas N52-34, Quito"
}
```

---

## 6. Instalacion y Ejecucion

### Requisitos previos

- Java 17+
- Maven 3.9+
- XAMPP 8.2.12-0 (instalado via script)

### a. Configurar XAMPP y base de datos

```bash
chmod +x scripts/xampp.sh
sudo ./scripts/xampp.sh
```

Esto instala XAMPP (si no está presente), arranca Apache y MySQL, crea la base de datos `webserver_db`, el usuario `springuser` y ejecuta los scripts SQL de inicialización.

### b. Encender servidor backend

```bash
mvn spring-boot:run
```

### Verificar

```bash
curl http://localhost:8081/api/productos/ping
```

---

> API ejecutandose en `http://localhost:8081`
