#!/bin/bash

# 1. Move to where the code actually is
# (We MUST do this so pip finds requirements.txt)
cd /home/ec2-user/server

# 2. Point to the Env file using its FULL ABSOLUTE PATH
# (We use /tmp/... so it works regardless of what folder we are in)
ENV_FILE="/tmp/codedeploy_env.sh"

if [ -f "$ENV_FILE" ]; then
    echo "Sourcing CodeDeploy environment variables from $ENV_FILE..."
    source "$ENV_FILE"
else
    echo "No CodeDeploy environment file found at $ENV_FILE"
fi

# 3. Now these commands will work because we are in the server folder
echo "Installing dependencies..."
# Using python3 -m pip is safer than just 'pip'
python3 -m pip install -r requirements.txt

echo "Starting application..."
nohup python3 app.py > app.log 2>&1 &