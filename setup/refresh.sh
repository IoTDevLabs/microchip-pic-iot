#!/bin/bash
CLOUD_REGION=us-central1

# color variables
RED='\033[0;31m'
BLU='\033[0;34m'
GRN='\033[0;32m'
PUR='\033[0;35m'
NC='\033[0m'

# log in to firebase
firebase login --no-localhost

# set the project and tell firebase to use it firebase
gcloud config set project $GOOGLE_CLOUD_PROJECT
firebase use $GOOGLE_CLOUD_PROJECT

#install npm dependencies
printf "${BLU}Installing Cloud Function dependencies (this may take a few minutes)...\n${NC}" 
npm install --prefix ./functions/
printf "\n${BLU}Installing UI dependencies (this may take a few minutes)...\n${NC}"
npm install --prefix ./ui/

# retrieve UI config vars 
firebase setup:web > config.txt
node getFirebaseConfig.js config.txt

# build UI
printf "${BLU}Creating a production build of the UI (this may take a few minutes)...\n${NC}"
npm run build --prefix ./ui

chmod +x ./ui/src/Config.js

firebase deploy --only functions:recordMessage
firebase deploy --only database
firebase deploy --only hosting

