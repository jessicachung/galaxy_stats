# Cron job scripts

Things that may need to be done before running:

- Create virtual environment with python-swiftclient and python-keystoneclient
- Add OpenStack credentials
- Change container name
- Change psql port


Cron job for galaxy-mel as user `ubuntu`:

```
0 0 1 * * bash /mnt/transient_nfs/galaxy_stats/cron/backup_galaxy_db.sh
```

Cron job for analysis server as user `mel`:

```
0 1 1 * * bash /mnt/transient_nfs/galaxy_stats/cron/import_and_analyse_galaxy_db.sh
```

R packages needed:

```
# Packages needed for rendering R notebooks
install.packages(c("evaluate", "formatR", "highr", "markdown", "yaml", "htmltools", "caTools", "bitops", "knitr", "rprojroot", "rmarkdown"))

# Packages needed for analysis
install.packages(c("RPostgreSQL", "lubridate", "openxlsx", "purrr"))
```
