#!/bin/bash
set +e
eval "$( aws ecr get-login --no-include-email --region eu-west-1 )"
docker pull 383646808490.dkr.ecr.eu-west-1.amazonaws.com/demainchezmoi/plum:latest
# docker stop $(docker ps -a -q)
# docker rm $(docker ps -a -q)
docker run -p 80:4000 -p 443:4000 --env-file .env -v googleauth.json:/opt/app/googleauth.json 383646808490.dkr.ecr.eu-west-1.amazonaws.com/demainchezmoi/plum:latest foreground
