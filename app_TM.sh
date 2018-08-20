#!/bin/sh
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# Script Name : app_TM.sh
#     Purpose : Top level wrapper script to invoke the Kjb and Ktr's and orchestrate the code execution
#       Usage : /app_TM.sh <RUN_DT,YYYY-MM-DD> <START_DT,YYYY-MM-DD> <END_DT,YYYY-MM-DD>
# Dependecies : The following variables needs to be available in the shell env prior invoking the script 
#               -- Pentaho
#               PENTAHO_HOME 
#               KETTLE_HOME
#               PROJECT_DIR
#               -- Path
#               INPUT_DIR
#               OUTPUT_DIR
#               LOOKUP_DIR
#               INTERIM_DIR
#               LOG_DIR
#               ERROR_DIR
#               REJECT_DIR
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
#              M  A  I  N     P  R  O  C  E  S  S  I  N  G                        #
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

# input parameters
RUN_DT=$1
START_DT=$2
END_DT=$3

# check for unset variables and abort if variables are not set correctly 
if [ -z $RUN_DT ] || [ -z $START_DT ] || [ -z $END_DT ]
then
        echo " "
        echo "Script: $0 started"
        echo "Error: At least one of the below variables is not set"
        echo "Error: RUN_DT, START_DT, END_DT"
        echo "Script: $0 failed"
        echo " "
        exit 1
fi

if [ -z $INPUT_DIR ] || [ -z $OUTPUT_DIR ] || [ -z $LOOKUP_DIR ] || [ -z $INTERIM_DIR ] || [ -z $LOG_DIR ] || [ -z $ERROR_DIR ] || [ -z $REJECT_DIR ]
then
        echo " "
        echo "Script: $0 started"
        echo "Error: At least one of the below variables is not set"
        echo "Error: INPUT_DIR, OUTPUT_DIR, LOOKUP_DIR, INTERIM_DIR, LOG_DIR, ERROR_DIR, REJECT_DIR"
        echo "Script: $0 failed"       
        echo " "
        exit 1
fi

echo " "
echo "Script: $0 started"
echo "Arguements: $@"
echo " "

# execute kjbs
# TradeMore
$PENTAHO_HOME/kitchen.sh -file $PROJECT_DIR/TM_tax_reports.kjb \
                        -param:RUN_DT=$RUN_DT -param:START_DT=$START_DT -param:END_DT=$END_DT \
                        -logfile=$LOG_DIR/TM_tax_reports_$START_DT_$$END_DT_$RUN_DT.log -level basic

# Check error code
if [ $? -ne 0 ]
then
  echo "TM_tax_reports.kjb failed"
  exit 1
else
  echo "TM_tax_reports.kjb executed successfully"
fi

echo "Script: $0 executed successfully"
