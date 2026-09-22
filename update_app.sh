#!/bin/bash
set -e

echo "Updating Stage 7 application..."

APP_DIR="/home/azureuser/stage6-app"
BRANCH="main"

cd "$APP_DIR"

GIT_SSH_COMMAND="ssh -i /home/azureuser/.ssh/stage7_github -o IdentitiesOnly=yes" git pull origin "$BRANCH"

docker compose pull

docker compose up -d --remove-orphans

docker image prune -f

echo "Deployment completed successfully."