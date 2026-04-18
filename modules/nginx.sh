echo "[+] Installing Nginx..."

apt install -y nginx

systemctl enable nginx
systemctl start nginx

systemctl is-active --quiet nginx || exit 1

echo "[✓] Nginx running"