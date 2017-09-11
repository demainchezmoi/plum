#!/bin/bash
docker-compose run plum mix dialyzer
docker-compose run test
mix docker.shipit
mix docker.publish --tag latest
ssh -i ~/.ssh/aws-eb4 ec2-user@34.253.234.153 'bash -s' < remote_deploy.sh
