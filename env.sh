#!/bin/bash

echo "Importing host IP for Sonar server, make sure your Sonar server is on this machine, else replace the hostname command with your IP"
SONAR_HOST_IP=$(hostname -I | cut -d' ' -f1)

echo "SonarQube is up, Make sure you fill the below requirements before proceeding further"
docker run -d \
    --name sonarqube \
    -p 9000:9000 \
    -e HOST_URL="$SONAR_HOST_URL" \
    -v sonarqube_data:/opt/sonarqube/data \
    sonarqube:latest

# Prompt the user for input without showing it
echo "Before continuing to the setup, please refer to the documentation and get the Sonar authentication token."
read -rsp "Enter Sonar Authentication token: " SONAR_AUTH_TOKEN_INPUT

echo -e "\nEnter Project Key. Make sure to refer to the documentation and create a Sonar project key."
read -rsp "Enter the Sonar project key: " SONAR_PROJECT_KEY_INPUT

# Set the user input as environment variables
export SONAR_AUTH_TOKEN="$SONAR_AUTH_TOKEN_INPUT"
export SONAR_PROJECT_KEY="$SONAR_PROJECT_KEY_INPUT"
export SONAR_HOST_URL="http://${SONAR_HOST_IP}:9000"

# Optional: Display a message confirming the setting of the environment variables
echo -e "\nEnvironment variables have been set."

# Display the environment variables
echo "SONAR_PROJECT_KEY: $SONAR_PROJECT_KEY"
echo "SONAR_AUTH_TOKEN: $SONAR_AUTH_TOKEN"
echo "SONAR_HOST_URL: $SONAR_HOST_URL"

# Check if any of the environment variables are empty
if [ -z "$SONAR_AUTH_TOKEN" ] || [ -z "$SONAR_PROJECT_KEY" ] || [ -z "$SONAR_HOST_URL" ]; then
    echo "One or more environment variables are empty. Exiting the script."
    # Display the environment variables
    echo "SONAR_PROJECT_KEY: $SONAR_PROJECT_KEY"
    echo "SONAR_AUTH_TOKEN: $SONAR_AUTH_TOKEN"
    echo "SONAR_HOST_URL: $SONAR_HOST_URL"
    exit 1
fi

# Check if SONAR_AUTH_TOKEN starts with 'sqa_'
if ! [[ "$SONAR_AUTH_TOKEN" =~ ^sqa_ ]]; then
    echo "Invalid Auth Token. Exiting the script."
    exit 1
fi

# Prompt the user for confirmation
read -rsp "Confirm, if your sonar-configurations are correct [yes/no]: " Confirmation

# Check the confirmation
if [ "$Confirmation" == "yes" ]; then
    echo -e "\nProceeding with the execution."
elif [ "$Confirmation" == "no" ]; then
    echo -e "\nExiting the script as per user request."
    exit 1
else
    echo -e "\nInvalid input. Please enter 'yes' or 'no'."
    exit 1
fi

docker run -d \
    --name jenkins \
    -p 8080:8080 \
    -e SONAR_PROJECT_KEY="$SONAR_PROJECT_KEY" \
    -e SONAR_AUTH_TOKEN="$SONAR_AUTH_TOKEN" \
    -e SONAR_HOST_URL="$SONAR_HOST_URL" \
    -v /home/poison/jenkins_compose/jenkins_configuration:/var \
    -v /var/run/docker.sock:/var/run/docker.sock
    sast:test1
