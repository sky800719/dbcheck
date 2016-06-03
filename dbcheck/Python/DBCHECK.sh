--FILESYSTEM_USAGE.sh
> FILESYSTEM_USAGE.txt
olsnodes > /dev/null 2>&1

if [ $? = 0 ]; then
        for nodename in `olsnodes`;
        do
                echo 'HOSTNAME|'$nodename >> FILESYSTEM_USAGE.txt
                ssh $nodename df -kP | awk '{print $1"|"int($2/1024)"|"int($3/1024)"|"int($4/1024)"|"$5"|"$6}' | grep -v Filesystem  >> FILESYSTEM_USAGE.txt
                echo '' >> FILESYSTEM_USAGE.txt
        done
else
        echo 'HOSTNAME|'`hostname` >> FILESYSTEM_USAGE.txt
        df -kP | awk '{print $1"|"int($2/1024)"|"int($3/1024)"|"int($4/1024)"|"$5"|"$6}' | grep -v Filesystem  >> FILESYSTEM_USAGE.txt
fi

--CRSSTAT.sh
crs_stat | awk \
'BEGIN { FS="="; state = 0; }
$1~/NAME/ && $2~/'$1'/ {appname = $2; state=1};
state == 0 {next;}
$1~/TARGET/ && state == 1 {apptarget = $2; state=2;}
$1~/STATE/ && state == 2 {appstate = $2; state=3;}
state == 3 {printf "%-40s""|""%-10s""|""%-18s\n", appname, apptarget, appstate; state=0;}'

--ALERT_PARSE.sh
> alert_temp.log
> ora_alert.tmp
> ALTER_INFO.txt

DBVER=`sqlplus -v | awk -F 'Release ' '{print $2}' | awk -F'.' '{print$1}' | grep -v ^$`
echo $DBVER

ALERTFILE=alert_$ORACLE_SID.log
if [ "$DBVER" -eq "11" ]; then
        ALERTFILE=$ORACLE_BASE/diag/rdbms/*/$ORACLE_SID/trace/alert_$ORACLE_SID.log
else
        ALERTFILE=$ORACLE_BASE/admin/*/bdump/alert_$ORACLE_SID.log
fi

CURRENT_DATE=`date "+%a %b %d"`
CURRENT_YEAR=`date "+%Y"`

TODAY_BEGIN=`cat -n $ALERTFILE | grep "${CURRENT_DATE}" | grep "${CURRENT_YEAR}" | head -1 | awk '{print $1}'`
ALERT_TOTAL=`cat $ALERTFILE | wc -l`

tail -$((${ALERT_TOTAL} - ${TODAY_BEGIN})) $ALERTFILE > alert_temp.log

more alert_temp.log | grep ^ORA- | awk -F':' '{print $1}' | sort | awk '{a[$1]+=1} END{for(i in a) print i"\t"a[i]}' | sort -rnk 2 > ora_alert.tmp

clear

for i in `more ora_alert.tmp | awk '{print $1}' | awk -F'-' '{print $2}'`
do
        echo "------------------------------ORA-ERROR $i-------------------------------------"
        cat ora_alert.tmp | grep ORA-$i
        oerr ora $i
        oracode=`cat ora_alert.tmp | grep ORA-$i | awk -F'\t' '{print $1"|"$2}'`
        orares=`oerr ora $i | grep $i, | awk -F',' '{print $3}'`
        echo $oracode"|"$orares >> ALTER_INFO.txt
        echo ""
        echo ""
done


echo '-------------------------------------------------------------------'

cat -n alert_temp.log | grep -v "ORA-" | grep -i -E 'error|warning|abort|kill|shutdown|evacuate|terminat|failed'

--DBCHECK_INIT.sh
CHECKBASE=/home/oracle/DB_CHECK
CHECKDB=$CHECKBASE/CHECKDB.TXT
WORK_DIR=$CHECKBASE/daycheck

CHECKDAY=`date "+%Y%m%d"`
echo $CHECKDAY > LASTDAY.lck

mkdir -p daycheck/$CHECKDAY