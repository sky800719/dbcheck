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
