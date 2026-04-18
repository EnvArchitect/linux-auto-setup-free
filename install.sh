#!/bin/bash

set -e

CONFIG_FILE="config.conf"
LOG_FILE="logs/setup.log"

mkdir -p logs

log() {
    echo -e "[INFO] $1"
    echo "[INFO] $1" >> $LOG_FILE
}

error_exit() {
    echo -e "[ERROR] $1"
    echo "[ERROR] $1" >> $LOG_FILE
    exit 1
}

banner() {
    echo "======================================="
    echo "   Linux Auto Setup Toolkit v1.0"
    echo "======================================="
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        error_exit "Run as root (sudo)"
    fi
}

check_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        error_exit "Config file missing"
    fi
}

run_module() {
    MODULE=$1
    if [ -f "$MODULE" ]; then
        log "Running $MODULE"
        bash $MODULE || error_exit "Failed: $MODULE"
    else
        error_exit "Module not found: $MODULE"
    fi
}

# ---- START ----
banner
check_root
check_config

source $CONFIG_FILE

log "Updating system..."
apt update -y && apt upgrade -y

[ "$CREATE_USER" = "yes" ] && run_module modules/user.sh
[ "$SETUP_FIREWALL" = "yes" ] && run_module modules/firewall.sh
[ "$INSTALL_DOCKER" = "yes" ] && run_module modules/docker.sh
[ "$INSTALL_NGINX" = "yes" ] && run_module modules/nginx.sh
[ "$ENABLE_BACKUP" = "yes" ] && run_module modules/backup.sh && run_module modules/cron.sh
[ "$ENABLE_MONITORING" = "yes" ] && run_module modules/monitor.sh

if [ "$DEPLOY_WEB" = "yes" ]; then
    run_module modules/deploy.sh
fi

if [ "$ENABLE_SSL" = "yes" ]; then
    run_module modules/ssl.sh
fi

