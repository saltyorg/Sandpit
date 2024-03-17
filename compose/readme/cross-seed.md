# So, you want to cross-seed

First off, make sure that you read their [Docs](https://www.cross-seed.org/docs/basics/getting-started). There are some considerations with how you want to set up the container, mainly daemon or search, and if you want direct injection into your client or the torrent added to a watch directory.

## What clients does cross-seed support?

Cross-seed supports rutorrent, transmission, and qbittorent.

## Does it work with tqm?

No. tqm will ignore any cross-seeded torrent.

## Get started

Grab the `config.js` [Template](https://github.com/cross-seed/cross-seed/blob/master/src/config.template.docker.cjs)

Fill it out as necessary for your download client.

### Saltbox specific

- qbittorent url
  - Your url would look like: `"http://username:password@qbittorrent:8080"`

- prowlarr torznab url
  - Your url would look like: `["http://prowlarr:9696/28/api?apikey=your_prowlarr_api_key", "http://prowlarr:9696/26/api?apikey=your_prowlarr_api_key"]`

Note that the number after the port refers to which indexer it is. The docs linked above explain that in more detail.
