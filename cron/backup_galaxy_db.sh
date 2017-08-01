#!/bin/bash
# Backup Galaxy database to Nectar object storage
# 
# # Before running, setup directory with virtual environment
# mkdir /mnt/transient_nfs/galaxy_db_backups/
# cd /mnt/transient_nfs/galaxy_db_backups/
# virtualenv venv
# source venv/bin/activate
# pip install python-swiftclient
# pip install python-keystoneclient

set -euo pipefail

cd /mnt/transient_nfs/galaxy_db_backups/

# Backup name: galaxy_backup_YYYY-MM-DD.sql
BACKUP=galaxy_backup_$(date +%F).sql
LOG=galaxy_backup.log

echo "[$(date --iso-8601=seconds)] Starting backup" >> ${LOG}

# Backup database to plain-text and compress
pg_dump \
    --file=${BACKUP} \
    postgres://galaxy@localhost:5930/galaxy
gzip ${BACKUP}

# Activate virtualenv for swift
source venv/bin/activate

# OS credentials
export OS_AUTH_URL=https://keystone.rc.nectar.org.au:5000/v2.0/
export OS_TENANT_ID=""
export OS_TENANT_NAME=""
export OS_PROJECT_NAME=""
export OS_USERNAME=""
export OS_PASSWORD=""

# Upload to object store
swift upload galaxy-mel-backups ${BACKUP}.gz

echo "[$(date --iso-8601=seconds)] Finished backup" >> ${LOG}
