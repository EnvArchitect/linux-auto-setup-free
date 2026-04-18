echo "[+] Deploying web page..."

cp -r web/* /var/www/html/

chown -R www-data:www-data /var/www/html/

echo "[✓] Web deployed"