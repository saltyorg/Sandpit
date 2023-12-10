# Firefly

So you want to get your finances in order, and you like tinkering? Well here you go.

Firefly docs: <https://docs.firefly-iii.org/firefly-iii>

Importer docs: <https://docs.firefly-iii.org/data-importer>

## Step One - Initial Setup

Get her set up. This is set up to use authelia as an auth provider out of the box. If you intend to disable authelia authentication, be aware of the security risks involved, being that this will potentially house very sensitive info. I have currated this entirely to fit within the saltbox eco system, so edit things with that in mind.

1. Clone the Sandpit repo (click the `Code` dropdown button above, and copy the https web url, ie <https://github.com/saltyorg/Sandpit.git>), ie `git clone https://github.com/saltyorg/Sandpit.git` or copy and paste the Firefly and Importer files, grab the relevant info somehow, and place them (for the purposes of this tutorial) in `/opt/firefly`.
2. Change all of the entries in the compose file containing `.domain.tld` with your domain and top level domain. (hint, its easy with the sandbox `Coder` role)
3. Look through `firefly.env` and `firefly.importer.env` and adjust or append the necessary info to each field as needed. You won't need to adjust the `AUTHENTICATION` variables in the `firefly.env` file, that is already set up to work with authelia.

## Step Two - ENV Files

Now that we have the compose file and both of our `.env` files in `/opt/firefly`, we'll need to make sure we have all of the secret keys and what not filled in.

### `firefly.env`

1. `SITE_OWNER:` this should be your email. Especially if you intend on sending email notifications.
2. `APP_KEY:` Follow the instructions provided, run `openssl rand -hex 16` and put the output from that in that field.
3. `TZ:` Fill this in as specified in the env file.
4. Mariadb info:

```shell
DB_CONNECTION=mysql
DB_HOST=mariadb
DB_PORT=3306
DB_DATABASE=firefly
DB_USERNAME=firefly
DB_PASSWORD=firefly
```

My suggestion is to keep this, and only change the password, to keep things simple. If you know what you're doing, go wild.

**Note**: _This next bit is assuming you do NOT have a mariadb instance, or a container capable of editing the databases within the mariadb container_.

The easiest way to do this would be to run `sb install mariadb,sandbox-adminer`. Once installed, go to `adminer.domain.tld`, change `Server` from **mysql** to **mariadb**, enter **root** for `Username`, and **password321** for `Password`. Then select Login.

Now, we select "**Create database**" near the top of the screen. Enter `firefly`, and then select `save`.

Great, now we have a database. You should now see `Database has been created. 23:07:55 SQL command` near the top of the page.

Next step is to select `Privileges`, just below the "Database has been created...." Message near the top of the screen. Select `Create User` near the top of the page. Enter your desired user and password. (Remember, this tutorial and the .env files expect you to use **user** `firefly` and **password** `firefly`, so if you veer off the path of this tutorial, edit the env file accordingly)

Tick the `All Privileges` and `Grant option` boxes, scroll to the bottom of the page and select "Save". Et Voila! Your database connection is ready to rock and roll.

5. `STATIC_CRON_TOKEN:` follow the instructions in the env file and create the key in command line with `openssl rand -hex 16`. Replace the text "REPLACEME" with your newly created hex-key.

**Note**: _This should not be the same key used for `APP_KEY`. Just run the command again_.

Any other sections can be filled out as you please, just remember it should be set up to work as is.

### `firefly.importer.env`

There isn't much configuration that NEEDS to be done here, fill in a few of the sections asking for your full url, like `VANITY_URL`. `FIREFLY_III_ACCESS_TOKEN` can be filled in after you have it up and running. You cannot fill it in prior to starting the container and accessing the web UI. Add your `TZ` and you're set.

## Step Three - Install Firefly

**Note**: _You will need `A records` in cloudflare or your dns provider for both firefly and importer. If you use cloudflare, its easiest to install saltys `ddns` container, which will automatically create the entries for you. Install with `sb install ddns`. Thats it._

Your working directory should look like this now;

```yaml
/opt/firefly/
├── firefly.env
├── firefly.importer.env
└── firefly.yml
```

run this command in your terminal:

```shell
mv firefly.yml docker-compose.yml
```

Now you can pull, create, and run your containers.

```shell
docker compose up -d 
```

If you want to see the logs for everything at once, run `docker compose logs -f` from the firefly directory.
