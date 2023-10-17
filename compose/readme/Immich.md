# Immich

You will need to create an A record in cloudflare or whomever your provider is for this to resolve, or alternatively, run the ddns role salty made, to automatically create the records in cloudflare. (`sb install ddns`) It works similarly to the regular roles, and will add a record for you for docker compose files. Make sure to edit the `labels` section of the compose file with your domain and top level domain. (IE `immich.APPNAME.TLD) Then correct any of the other things that may be different for you, which I'll list:

1. User mapping:
```yaml
    environment:
      - PUID=1000
      - PGID=1001
```
to find your puid & guid, type `id` in your terminal, and put the corresponding numbers in each puid & pgid env in the compose. This will correct any permissions issues.

2. Create the subdirectories for each container under the root dir you are holding the compose file in. If you don't like the `/opt/immich` dir be sure to update them all accordingly. If you don't create the subdirectories they'll be owned by root, and you'll need to correct that manually.
`mkdir -p /opt/immich/model-cache` for example, according to the machine learning container.
ie:

```yaml
    volumes:
      - /opt/immich/model-cache:/cache
```

3. Lastly, and I'm not sure if this is necessary, run this to allow you to change your name from admin to whatever you choose. `docker exec immich_server sed -i 's/$1/$@/g' /usr/src/app/start.sh`

Happy image processing!
