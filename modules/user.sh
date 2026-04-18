echo "[+] Creating user..."

if id "$NEW_USERNAME" &>/dev/null; then
    echo "[!] User already exists"
else
    adduser --disabled-password --gecos "" $NEW_USERNAME
    usermod -aG sudo $NEW_USERNAME
    echo "[✓] User created: $NEW_USERNAME"
fi