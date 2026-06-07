CREATE DATABASE IF NOT EXISTS webserver_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'springuser'@'%' IDENTIFIED BY 'spring456';

GRANT ALL PRIVILEGES ON webserver_db.* TO 'springuser'@'%';

FLUSH PRIVILEGES;

USE webserver_db;

CREATE TABLE IF NOT EXISTS productos (
    id BIGINT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    PRIMARY KEY (id)
);
