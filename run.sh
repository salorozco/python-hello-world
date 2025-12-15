#!/bin/bash

# 1. Move to where the code actually is (Matches your appspec.yml)
cd /tmp

# 2. Point to the Env file 
ENV_FILE="/tmp/codedeploy_env.sh"

if [ -f "$ENV_FILE" ]; then
    echo "Sourcing CodeDeploy environment variables from $ENV_FILE..."
    source "$ENV_FILE"
else
    echo "No CodeDeploy environment file found at $ENV_FILE"
fi

# 3. Install and Run
echo "Installing dependencies..."
python3 -m pip install -r requirements.txt

echo "Starting application..."
nohup python3 app.py > app.log 2>&1 &