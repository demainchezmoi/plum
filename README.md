## Setup

  * Get your env vars:
    * Copy template file: `cp .env.template .env`
    * Fil values
  * Build containers: `docker-compose build`
  * Load db dump:
    * create db in container: `docker exec -i <container_id> psql -U postgres -c 'create database plum_dev'`
    * get data container id: `docker ps` and then look for `mdillon/postgis` container docker id
    * load dump in container: `cat <dump.sql> | docker exec -i <container_id> psql -U postgres --dbname plum_dev
    * apply latest migrations : `docker-compose run plum mix ecto.migrate`

## Run

  * dev: `docker-compose run --service-ports --rm plum iex -S mix phoenix.server`
  * test: `docker-compose run --rm test mix test.watch [file[:line]]`

## Archive
  * git archive : `git archive -v -o plum.zip --format=zip HEAD`
  * zip after release : `zip plum.zip plum.tar.gz Dockerfile`

## Console in prod
  * `eb ssh`
  * `docker ps`
  * `sudo docker exec -it <container_id> /opt/app/bin/plum remote_console`
