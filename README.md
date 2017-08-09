# Galaxy Database Stats

Use the Galaxy PostgreSQL database to query for stats. Access the database
in R using the RPostgreSQL library and analyse the data.

## PostgreSQL

SSH into the VM. Check the port for the database in the galaxy.ini file.
Connect to the database.

```bash
# Connect using the postgres user for superuser powers
psql postgres://postgres@localhost:5950/galaxy
```

Create the user `ubuntu` and grant `SELECT` privileges.

```sql
CREATE ROLE ubuntu WITH LOGIN PASSWORD '';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO ubuntu;
\q
```

## Rstudio

Log into RStudio as `researcher`. Install packages needed for RMarkdown
notebooks if necessary. Install RPostgreSQL and load the library.

```python
install.packages("RPostgreSQL")
library("RPostgreSQL")
```

Load driver and create a connection.

```python
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = "galaxy", host = "localhost", port = 5950,
                 user = "ubuntu")
````

Query the database ([CRAN RPostgreSQL manual](https://cran.r-project.org/web/packages/RPostgreSQL/RPostgreSQL.pdf)).

```python
dbExistsTable(con, "galaxy_user")
dbGetQuery(con, "SELECT * FROM galaxy_user LIMIT 10;")
```

Analysis notebook: [galaxy_stats.Rmd](galaxy_stats.Rmd)
