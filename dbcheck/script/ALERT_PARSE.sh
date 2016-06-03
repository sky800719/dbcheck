> alert_temp.log
> alert_code.tmp
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

more alert_temp.log | grep ^ORA- | awk -F':' '{print $1}' | sort | awk '{a[$1]+=1} END{for(i in a) print i"\t"a[i]}' | sort -rnk 2 > alert_code.tmp

clear

for i in `more alert_code.tmp | awk '{print $1}' | awk -F'-' '{print $2}'`
do
        echo "------------------------------ORA-ERROR $i-------------------------------------"
        cat alert_code.tmp | grep ORA-$i
        oerr ora $i
        oracode=`cat alert_code.tmp | grep ORA-$i | awk -F'\t' '{print $1"|"$2}'`
        orares=`oerr ora $i | grep $i, | awk -F',' '{print $3}'`
        echo $oracode"|"$orares >> ALTER_INFO.txt
        echo ""
        echo ""
done


echo '-------------------------------------------------------------------'

cat -n alert_temp.log | grep -v "ORA-" | grep -i -E 'error|warning|abort|kill|shutdown|evacuate|terminat|failed'
