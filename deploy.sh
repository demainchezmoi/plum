#!/bin/bash
set -e
docker-compose run --rm plum mix dialyzer --halt-exit-status
docker-compose run --rm test
eval "$( aws ecr get-login --no-include-email --region eu-west-1 )"
mix docker.shipit
mix docker.publish --tag latest
ssh -i ~/.ssh/aws-eb4 ec2-user@54.194.151.97 'bash -s' < remote_deploy.sh
