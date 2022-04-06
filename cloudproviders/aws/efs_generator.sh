#!/bin/bash

# Read the user input   
  
echo "Enter the flow-modules efs id: "  
read flow_modules_efs_id
echo "Enter the functions efs id: "  
read functions_efs_id
echo "Enter the region: "
read region

DIR="efs"

if [ -d "$DIR" ] 
then
    echo "efs folder already existes"
else
    cp -a efs.template/. efs/
    sed -i '' 's/flow-module-file-system/'"$flow_modules_efs_id"'/g' efs/efs-flow-modules.yaml
    sed -i '' 's/functions-file-system/'"$functions_efs_id"'/g' efs/efs-functions.yaml
    sed -i '' 's/region/'"$region"'/g' efs/*.yaml
fi 