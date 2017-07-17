#!/bin/bash
################################################################
#
# File: workflow.sh
# Author: Michael Souffront
# Purpose: Run RAPID process and move it to SPT tool server
#          
################################################################

# define home directory
HOME=/home/cecsr
WORKFLOW_DIR=$HOME/scripts/workflow

# create log file and date variables
DATE=$(date +"%Y%m%d.%H%M%S")
TODAY=$(date +"%Y%m%d")
DATE_LIMIT=$(date -d "$TODAY - 14 days" +"%Y%m%d")
LOG=$WORKFLOW_DIR/logs/workflow_$DATE.log
echo Initializing log >> $LOG

# run the ecmwf/rapid process
echo "Running RAPID process (see details at ~/logs)" >> $LOG
python $HOME/scripts/run.py

# copy output files to SPT server
while read watershed
do
  # check that there are outputs in the watershed folders
  if [[ `find $HOME/rapid-io/output/$watershed/ -mindepth 1 -type d | wc -l` > 0 ]]
  then
    while read rawdate
    do
      # check that the outputs are within two weeks from current date
      if [[ "${rawdate:0:8}" > "$DATE_LIMIT" ]]
      then
        # modify date formats
        if [ ${rawdate:9:10} == "00" ]
        then
          DATE_LOCAL_FORMAT=$rawdate
          DATE_EXT_FORMAT=${rawdate:0:10}
        else
          DATE_LOCAL_FORMAT=$rawdate
          DATE_EXT_FORMAT=${rawdate:0:11}"00"
        fi
        # copy outputs to SPT server
        . $WORKFLOW_DIR/copy_output_to_servers.sh $watershed $DATE_LOCAL_FORMAT $DATE_EXT_FORMAT >> $LOG
      else
        echo "Skipping available date older than two weeks" >> $LOG
#        echo "Deleting dates older than two weeks" >> $LOG
#        rm -r $HOME/rapid-io/output/$watershed/$rawdate
      fi
    done < <(ls -d $HOME/rapid-io/output/$watershed/*/ | xargs -n 1 basename)
  else
    echo $watershed" directory is empty" >> $LOG
  fi
done < <(ls -d $HOME/rapid-io/input/*/ | xargs -n 1 basename)
