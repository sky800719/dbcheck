SCRIPTBASE=/home/oracle/DB_CHECK
$SCRIPTBASE/script/CRSSTAT.sh > CLUSTER_STATUS.txt
$SCRIPTBASE/script/FILESYSTEM_USAGE.sh
$SCRIPTBASE/script/ALERT_PARSE.sh > alert_parse.log

cd $SCRIPTBASE

LASTDAY=`cat LASTDAY.lck`

mv *.txt $SCRIPTBASE/daycheck/$LASTDAY/
mv alert*.* $SCRIPTBASE/tmp
