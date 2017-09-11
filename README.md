## Setup

  * Get your env vars:
    * Copy template file: `cp .env.template .env`
    * Fil values
  * Build containers: `docker-compose build plum`
  * Load db dump:
    * create db in container: `docker exec -i <container_id> psql -U postgres -c 'create database plum_dev'`
    * get data container id: `docker ps` and then look for `mdillon/postgis` container docker id
    * load dump in container: `cat <dump.sql> | docker exec -i <container_id> psql -U postgres --dbname plum_dev
    * apply latest migrations : `docker-compose run plum mix ecto.migrate`

## Run

  * dev: `docker-compose run --service-ports --rm plum iex -S mix phoenix.server`
  * test: `docker-compose run --rm test mix test.watch [file[:line]]`

## Build
  * Obtain aws credentials: `aws ecr get-login --no-include-email --region eu-west-1`
  * Build, release and publish image: `mix docker.shipit`

## Connect
  * SSH: `ssh -i ~/.ssh/aws-eb4 ec2-user@34.253.234.153`
  * Start app: `docker run -p 80:4000 -it --env-file .env 383646808490.dkr.ecr.eu-west-1.amazonaws.com/demainchezmoi/plum:<version> foreground`
  * Connect to running app: `docker ps` then `sudo docker exec -it <container_id> /opt/app/bin/plum remote_console`
