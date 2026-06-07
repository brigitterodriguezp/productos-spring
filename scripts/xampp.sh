#!/bin/bash

set -e

XAMPP_VERSION="8.2.12-0"
XAMPP_FILE="xampp-linux-x64-${XAMPP_VERSION}-installer.run"
XAMPP_URL="https://sourceforge.net/projects/xampp/files/XAMPP%20Linux/${XAMPP_VERSION}/${XAMPP_FILE}/download"
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

is_xampp_installed() {
	[[ -x "/opt/lampp/lampp" ]]
}

download_xampp() {
	cd /tmp
	wget -O "$XAMPP_FILE" "$XAMPP_URL"
	chmod +x "$XAMPP_FILE"
}

install_xampp() {
	sudo "/tmp/$XAMPP_FILE"
}

start_xampp() {
	sudo /opt/lampp/lampp start
}

stop_xampp() {
	sudo /opt/lampp/lampp stop
}

setup_database() {
	local mysql="/opt/lampp/bin/mysql"

	$mysql -u root <<-EOSQL
		CREATE DATABASE IF NOT EXISTS webserver_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
		CREATE USER IF NOT EXISTS 'springuser'@'localhost' IDENTIFIED BY 'spring456';
		CREATE USER IF NOT EXISTS 'springuser'@'%' IDENTIFIED BY 'spring456';
		GRANT ALL PRIVILEGES ON webserver_db.* TO 'springuser'@'localhost';
		GRANT ALL PRIVILEGES ON webserver_db.* TO 'springuser'@'%';
		FLUSH PRIVILEGES;
	EOSQL

	echo "Running schema..."
	$mysql -u root webserver_db < "$SCRIPT_DIR/database/01_schema.sql"

	echo "Running schema clientes..."
	$mysql -u root webserver_db < "$SCRIPT_DIR/database/03_schema_cliente.sql"

	echo "Running seed data..."
	$mysql -u root webserver_db < "$SCRIPT_DIR/database/02_datos_de_prueba.sql"

	echo "Running seed data clientes..."
	$mysql -u root webserver_db < "$SCRIPT_DIR/database/04_datos_cliente.sql"
}

main() {
	if is_xampp_installed; then
		echo "XAMPP is already installed."
		start_xampp
	else
		download_xampp
		install_xampp
		start_xampp
	fi

	echo "Setting up database..."
	setup_database

	echo "XAMPP setup completed."
	echo ""
	echo "Start the app with: mvn spring-boot:run"
	echo "API available at: http://localhost:8081/api/productos/ping"
}

main "$@"
