#!/bin/bash
################################################################
#
# File: workflow.sh
# Author: Michael Souffront
# Purpose: Delete old forecasts from SPT tool server
#          
################################################################

# define home directory
HOME=/home/tethys
WORKFLOW_DIR=$HOME/tethys/spt_files/ecmwf

# create date variables
TODAY=$(date +"%Y%m%d")
DATE_LIMIT=$(date -d "$TODAY - 7 days" +"%Y%m%d")

# delete old forecasts
while read watershed
do
  # check that there are outputs in the watershed folders
  if [[ `find $WORKFLOW_DIR/$watershed/ -mindepth 1 -type d | wc -l` > 0 ]]
  then
    while read rawdate
    do
      # delete forecasts older than date limit
      if [[ "${rawdate:0:8}" < "$DATE_LIMIT" ]]
      then
        rm -r $WORKFLOW_DIR/$watershed/$rawdate
      fi
    done < <(ls -d $WORKFLOW_DIR/$watershed/*/ | xargs -n 1 basename)
  fi
done < <(ls -d $WORKFLOW_DIR/*/ | xargs -n 1 basename)
