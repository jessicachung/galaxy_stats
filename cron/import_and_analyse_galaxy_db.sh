#!/bin/bash
# Import Galaxy database from Nectar object storage and output stats
# 
# # Before running, setup directory
# mkdir /mnt/transient_nfs/
# git clone https://github.com/jessicachung/galaxy_stats.git
# cd galaxy_stats
# virtualenv venv
# source venv/bin/activate
# pip install python-swiftclient
# pip install python-keystoneclient

set -eo pipefail

cd /mnt/transient_nfs/galaxy_stats

# Backup name: galaxy_backup_YYYY-MM-DD.sql
BACKUP=galaxy_backup_$(date +%F).sql
LOG=galaxy_analysis.log

echo "[$(date --iso-8601=seconds)] Downloading and importing database" >> ${LOG}

# Activate virtualenv for swift
source venv/bin/activate

# OS credentials
export OS_AUTH_URL=https://keystone.rc.nectar.org.au:5000/v2.0/
export OS_TENANT_ID=""
export OS_TENANT_NAME=""
export OS_PROJECT_NAME=""
export OS_USERNAME=""
export OS_PASSWORD=""

# Download from object store
swift download galaxy-mel-backups ${BACKUP}.gz

# Create a new database
createdb -p 5950 -U galaxy mel-backup

# Import database
zcat ${BACKUP}.gz | psql postgres://galaxy@localhost:5950/mel-backup \
    > import.log 2>&1

echo "[$(date --iso-8601=seconds)] Starting analysis" >> ${LOG}

# Render R notebook
Rscript -e "dir <- paste0('/mnt/galaxy/home/jess/public_html/galaxy_mel_', as.character(Sys.Date())); rmarkdown::render('galaxy_stats.Rmd', output_dir=dir, knit_root_dir=dir, quiet=TRUE)" > /dev/null 2>&1

# Remove galaxy database
dropdb -p 5950 -U galaxy mel-backup

echo "[$(date --iso-8601=seconds)] Finished" >> ${LOG}

