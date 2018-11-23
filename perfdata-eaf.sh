#!/bin/bash
#this script get perf data for proceses stated in PROC array,
#Author: Ernesto A Farias
#set -x
PROC1=(procx java)
UNTIL='2018-11-24 16:34:59'
FREC=60 #frecuency in seconds

echo "collect proc Perfdata, parameters runUNTIL FRECquency and PROCesses\n it uses ps aux | grep procname and sum the proceses if more than 1"
echo "for background run as nohup /opt/wh-utils/perfdata-eaf.sh 2> /dev/null &"
echo "requires bc"

#create file
for i in "${PROC1[@]}"
do
HORA=$(date +"%H")
DIA=$(date +"%d")
MES=$(date +"%m")
ANO=$(date +"%Y")
MIN=$(date +"%M")
FILE="perfdata-$i-$ANO-$MES-$DIA.csv"

#if no file create this
if [ ! -f $FILE ];
then
echo "creating $FILE";
#touch $FILE
echo "TSdate,TStime,COUNT,OVERAL-MEM%,OVERAL-CPU%,OVERAL-RSS-KB,OVERAL-VSZ-KB" > $FILE
fi

echo "writing file for $i"
done


DATE=`date +"%H:%M:%S"`
UNTILDATE=$(date -d "$UNTIL" '+%s')
NOWDATE=$(date -d "$DATE" '+%s')


while [ $UNTILDATE -gt $NOWDATE ];
do
    #for each process get a line
    for i in "${PROC1[@]}"
    do
    NOWDATE=$(date -d "$DATE" '+%s')
    #echo -n "$DATE, " | tee -a $FILE
    #uptime
    #echo "scale=3; ($var*$total/100)" | bc | tee -a $FILE
    GETPIDCMD=`/bin/pidof $i`
    PIDARRAY="("${GETPIDCMD}")"
	GREPFILTER=${GETPIDCMD//[' ']/'\|'}
#	echo "PIDCMD " ${GETPIDCMD}
#    echo "PIDARRAY " $PIDARRAY
#    echo "GFILTER " $GREPFILTER

   PSOUTPUT=`ps aux | grep $GREPFILTER 2>/dev/null`
    echo "PSOUTPUT" $PSOUTPUT
    OIFS="${IFS}"
    NIFS=$'\n'
    IFS="${NIFS}"

    OVERALCPU=0.0
    OVERALMEM=0.0
    OVERALRSS=0.0
    OVERALVSZ=0.0
    COUNT=0
    DATELOG=`date +"%Y-%m-%d,%H:%M:%S"`


        for LINE in ${PSOUTPUT}; do
                CPU=$(echo $LINE | awk '{ print $3 }')
                COMMAND=$(echo $LINE | awk '{ print $11 }')
                MEM=$(echo $LINE | awk '{ print $4 }')
                RSS=$(echo $LINE | awk '{ print $6 }')
                VSZ=$(echo $LINE | awk '{ print $5 }')

                if [[ $COMMAND == *$i* ]]; then
                    OVERALCPU=`echo "${OVERALCPU} + ${CPU}" | bc -l`
                    OVERALMEM=`echo "${OVERALMEM} + ${MEM}" | bc -l`
                    OVERALRSS=`echo "${OVERALRSS} + ${RSS}" | bc -l`
                    OVERALVSZ=`echo "${OVERALVSZ} + ${VSZ}" | bc -l`
                    COUNT=`echo "${COUNT} + 1" | bc -l`
                    ACTCOMMAND=$COMMAND
                fi
        done
    echo "write $i"
    IFS="${OIFS}"
    echo "${DATELOG},${COUNT},${OVERALMEM},${OVERALCPU},${OVERALRSS},${OVERALVSZ}" >> perfdata-$i-$ANO-$MES-$DIA.csv
    #echo "${EXITTEXT} ${ACTCOMMAND} CPU: ${OVERALCPU}% MEM: ${OVERALMEM}% over ${COUNT} processes | proc=${COUNT} rss=${OVERALRSS}KB vsz=${OVERALVSZ}KB"
done

sleep $FREC
done

