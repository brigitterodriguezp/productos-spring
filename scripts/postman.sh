#!/bin/bash

set -e

ARCHIVE="$HOME/Downloads/postman-linux-x64.tar.gz"
INSTALL_DIR="/opt/Postman"
BIN_LINK="/usr/local/bin/postman"
DESKTOP_FILE="/usr/share/applications/postman.desktop"

is_postman_installed() {
	[[ -x "$INSTALL_DIR/Postman" ]]
}

archive_exists() {
	[[ -f "$ARCHIVE" ]]
}

remove_previous_installation() {
	sudo rm -rf "$INSTALL_DIR"
}

extract_postman() {
	sudo tar -xzf "$ARCHIVE" -C /opt
}

create_bin_link() {
	sudo ln -sf "$INSTALL_DIR/Postman" "$BIN_LINK"
}

create_desktop_launcher() {
	sudo tee "$DESKTOP_FILE" >/dev/null <<EOF
[Desktop Entry]
Name=Postman
Exec=$INSTALL_DIR/Postman
Icon=$INSTALL_DIR/app/resources/app/assets/icon.png
Type=Application
Categories=Development;
EOF
}

install_postman() {
	remove_previous_installation
	extract_postman
	create_bin_link
	create_desktop_launcher
}

main() {
	if is_postman_installed; then
		echo "Postman is already installed."
		exit 0
	fi

	if ! archive_exists; then
		echo "Postman archive not found: $ARCHIVE"
		exit 1
	fi

	install_postman

	echo "Postman installation completed."
	echo "Run with: postman"
}

main "$@"