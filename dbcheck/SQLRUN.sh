. ~/.bash_profile

sqlplus -S / as sysdba << CHECK
@./script/DBCHECK.sql
CHECK

LASTDAY=`cat LASTDAY.lck`

mv *.txt ./daycheck/$LASTDAY/
