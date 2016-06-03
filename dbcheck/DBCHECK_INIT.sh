CHECKBASE=/home/oracle/DB_CHECK
CHECKDB=$CHECKBASE/CHECKDB.TXT
WORK_DIR=$CHECKBASE/daycheck

CHECKDAY=`date "+%Y%m%d"`
echo $CHECKDAY > LASTDAY.lck

mkdir -p daycheck/$CHECKDAY
mkdir tmp
