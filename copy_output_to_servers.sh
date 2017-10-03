TETHYS_PATH=/rapid/ecmwf/$1
TETHYS_SERVER=tethys@tethys.byu.edu

TETHYS_STAGING_PATH=/home/tethys/tethys/spt_files/ecmwf/$1
TETHYS_STAGING_SERVER=tethys@tethys-staging.byu.edu

# make sure watershed folder exists
#ssh -n $TETHYS_SERVER "mkdir -p $TETHYS_PATH"
ssh -n $TETHYS_STAGING_SERVER "mkdir -p $TETHYS_STAGING_PATH"

# syncs results between servers
#echo Copying $1/$2 to $TETHYS_SERVER:$TETHYS_PATH/$3
#rsync --ignore-existing ~/rapid-io/output/$1/$2/* $TETHYS_SERVER:$TETHYS_PATH/$3/

echo Copying $1/$2 to $TETHYS_STAGING_SERVER:$TETHYS_STAGING_PATH/$3
rsync --ignore-existing ~/rapid-io/output/$1/$2/* $TETHYS_STAGING_SERVER:$TETHYS_STAGING_PATH/$3/
