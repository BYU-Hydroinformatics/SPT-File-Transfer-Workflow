TETHYS_PATH=/rapid/ecmwf/$1
TETHYS_SERVER=tethys@tethys.byu.edu

# make sure watershed folder exists
ssh -n $TETHYS_SERVER "mkdir -p $TETHYS_PATH"

# syncs results between servers
echo Copying $1/$2 to $TETHYS_SERVER:$TETHYS_PATH/$3
rsync --ignore-existing ~/rapid-io/output/$1/$2/* $TETHYS_SERVER:$TETHYS_PATH/$3/

# delete results once copied
#echo Deleting local version of /$1/$2
#rm -r ~/rapid-io/output/$1/$2
