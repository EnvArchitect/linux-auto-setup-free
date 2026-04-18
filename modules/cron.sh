#!/bin/bash

echo "[+] Setting up cron job..."

(crontab -l 2>/dev/null; echo "0 2 * * * bash $(pwd)/modules/backup.sh") | crontab -

echo "[✓] Daily backup scheduled at 02:00"