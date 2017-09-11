set +e

echo "Runnint post_start script"

while true; do  
  nodetool ping
  EXIT_CODE=$?
  if [ $EXIT_CODE -eq 0 ]; then
    echo "Application is up!"
    break
  fi
done

set -e

echo "Running migrations"  
bin/plum rpc Elixir.Release.Tasks create  
bin/plum rpc Elixir.Release.Tasks migrate  
echo "Migrations run successfully"
