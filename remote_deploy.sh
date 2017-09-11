#!/bin/bash
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi 383646808490.dkr.ecr.eu-west-1.amazonaws.com/demainchezmoi/plum:latest
docker run -p 80:4000 --env-file .env 383646808490.dkr.ecr.eu-west-1.amazonaws.com/demainchezmoi/plum:latest foreground
