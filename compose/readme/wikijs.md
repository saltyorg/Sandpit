# This [compose](https://github.com/bad-CHAIR/Saltbox-Compose-Examples/blob/main/Wiki-js/docker-compose.yml) file is made assuming you have an existing postgres instance on your server. 

If you don't, run:

```yaml
sb install postgres
```
The default user I believe to be saltbox, it could be your server user from `accounts.yml`

# To administrate your PG instance, install PGAdmin. 

Run:

```yaml
sb install sandbox-pgadmin
```

Pgadmin is listed in the sb docs. You can create a db user, db pass, and a db from there. 
