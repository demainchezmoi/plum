#!/bin/bash
set +e
eval "$( aws ecr get-login --no-include-email --region eu-west-1 )"
docker pull 383646808490.dkr.ecr.eu-west-1.amazonaws.com/demainchezmoi/plum:latest
docker ps -q | xargs docker stop
docker ps -q | xargs docker rm
docker images -f "dangling=true" -q | xargs docker rmi
docker run -p 80:4000 --env-file .env -v /home/ec2-user/.google-auth.json:/opt/app/.google-auth.json 383646808490.dkr.ecr.eu-west-1.amazonaws.com/demainchezmoi/plum:latest foreground
