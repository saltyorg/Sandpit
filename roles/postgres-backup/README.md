# Postgres-Backup

## What is this?

This role will get a list of all of your PostgreSQL databases on each instance and dump all of the databases to `/opt/db-backup/<postgres_instance>/<database_name>.tar.gz`. The role loops through your defined `postgres_instances` in Saltbox.
