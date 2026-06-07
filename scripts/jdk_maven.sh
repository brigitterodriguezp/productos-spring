#!/bin/bash

set -e

JDK_PACKAGE="openjdk-17-jdk"
MAVEN_PACKAGE="maven"

is_jdk_installed() {
	java -version &>/dev/null 2>&1
}

is_maven_installed() {
	mvn -version &>/dev/null 2>&1
}

install_jdk() {
	echo "Installing JDK 17..."
	sudo apt update
	sudo apt install -y "$JDK_PACKAGE"
}

install_maven() {
	echo "Installing Maven..."
	sudo apt install -y "$MAVEN_PACKAGE"
}

verify() {
	echo ""
	echo "=== Verificacion ==="
	echo -n "JDK: "
	java -version 2>&1 | head -1
	echo -n "Maven: "
	mvn -version 2>&1 | head -1
}

main() {
	if is_jdk_installed; then
		echo "JDK 17 is already installed."
	else
		install_jdk
	fi

	if is_maven_installed; then
		echo "Maven is already installed."
	else
		install_maven
	fi

	verify
}

main "$@"
