just clone the standardnotes repo from their docs, run bash server.sh setup, remove the existing docker compose file, put mine in there, edit the like 2 entries you need to. I think theres like 5 commands you just copy and paste one at a time into the terminal. run bash server.sh start wait 1 minute. add an entry into cloudflare. go to standard notes and register.
when you register, to check that your api-gateway is running and working correctly, run `curl https://api-gateway.domain.tld/healthcheck` and if it returns ok then you are good to register. when you register click advanced, custom server, and put the above address (minus healthcheck) in there and done
so if you decide to do it look here ^^^ : )

will actually set this up better later. here is a garbage version of a Readme. 
