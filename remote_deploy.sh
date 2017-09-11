#!/bin/bash
docker pull 383646808490.dkr.ecr.eu-west-1.amazonaws.com/demainchezmoi/plum:latest
docker stop $(docker ps -a -q)
docker run -p 80:4000 --env-file .env 383646808490.dkr.ecr.eu-west-1.amazonaws.com/demainchezmoi/plum:latest foreground
docker rm $(docker ps -a -q)
