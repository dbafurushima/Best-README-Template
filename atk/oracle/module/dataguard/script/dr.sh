#!/bin/bash
echo''
echo "Automation Tool Kit - atk"
echo ''
 . ~oracle/.bash_profile >> /dev/null



export LOG_DIR=$ATK_ORACLE_MODULE_DATAGUARD_SCRIPT/log
export LOG=$LOG_DIR/dr.log
. $ATK_ORACLE_MODULE_DATAGUARD_SCRIPT/setoraenv.sh > /dev/null


LogRotate () {
  local f="$1"
  local limit=$2

# Deletes old log file
  if [ -f $f ] ; then
    CNT=${limit}
    let P_CNT=CNT-1
    if [ -f ${f}.${limit} ] ; then
      rm ${f}.${limit}
    fi

# Renames logs .1 trough .4
    while [[ $CNT -ne 1 ]] ; do
      if [ -f ${f}.${P_CNT} ] ; then
        mv ${f}.${P_CNT} ${f}.${CNT}
      fi
      let CNT=CNT-1
      let P_CNT=P_CNT-1
    done

# Renames current log to .1
    mv $f ${f}.1
    echo "" > $f
  fi
}

function check_db {
echo ''
#  CONNECTION=$1
  RETVAL=`sqlplus -silent $CONNECTION <<EOF
SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
select 'Alive' from dual ;
EXIT;
EOF`



  if [ "$RETVAL" = "Alive" ]; then
    DB_OK=0
    echo "TEST DB CONNECT" $TNS_CONNECT ".........OK" |tee -a $LOG
export v_DB_NAME=$(echo "SET HEAD OFF
      set feedback off verify off heading off pagesize 0
      select NAME from v\$database ; 
      exit" | $ORACLE_HOME/bin/sqlplus -silent $CONNECTION )

export v_DATABASE_RULE=$(echo "SET HEAD OFF
        set feedback off verify off heading off pagesize 0
        select DATABASE_ROLE from v\$database ; 
        exit" | $ORACLE_HOME/bin/sqlplus -silent $CONNECTION )

export v_DGBROKER=$(echo "SET HEAD OFF
        set feedback off verify off heading off pagesize 0
        select DATAGUARD_BROKER from v\$database ;
        exit" | $ORACLE_HOME/bin/sqlplus -silent $CONNECTION )


  else
    DB_OK=1
    echo "TEST DB CONNECT" $TNS_CONNECT ".........NOK" |tee -a $LOG
    exit 1
  fi
}


if [ -d $LOG_DIR ]; then
  LogRotate $LOG 10
else
  echo "Criando LOG_DIR: $LOG_DIR"
  mkdir -p $LOG_DIR
fi


# echo '' > $LOG



. ~oracle/.bash_profile > /dev/null
. $ATK_HOME/conf/create_atk_dirs.sh > /dev/null



for i in "$@"
do
case $i in
    -s=*|--standby=*)
    STANDBY="${i#*=}"
    ;;
    -p=*|--primary=*)
    PRIMARY="${i#*=}"
    ;;
    -db=*|--dbname=*)
    DBNAME="${i#*=}"
    ;;
    -op=*|--operation=*)
    OPS="${i#*=}"
    ;;
    --bolha=*)
    OPS='bolha'
    BOLHA="${i#*=}"
    ;;
    --default)
    DEFAULT=YES
    ;;
    *)
            # unknown option
    ;;
esac
done

if [[ "$OPS" == "bolha" && "$BOLHA" == "STANDBY" ]]; then
export NOCHECK_STANDBY=ON
else 
export NOCHECK_STANDBY=OFF
fi



array=("unregister" "register" "validate" "chaveamento" "bolha")
elem_aux=$OPS
export elem=$(echo $elem_aux |  tr '[:upper:]' '[:lower:]')
#echo $elem

if c=$'\x1E' && p="${c}${elem} ${c}" && [[ ! "${array[@]/#/${c}} ${c}" =~ $p ]]; then
echo "OPERATION $elem not valid"
exit 1
else
echo "OPERATION operation selected for execution : " $elem
fi

# echo Primary : $PRIMARY
# echo Standby : $STANDBY

if [ -z "$PRIMARY" ] || [ -z "$STANDBY" ] ; then

  echo 'one or more variables are undefined' |tee -a $LOG
  echo PRIMARY is set to value ${PRIMARY} |tee -a $LOG
  echo STANDBY is set to value ${STANDBY} |tee -a $LOG
  echo ENV.........NOK |tee -a $LOG

  exit 1

else

  unset TNS_ADMIN
  export TNSPING_PRIMARY=$($ORACLE_HOME/bin/tnsping ${PRIMARY} |tail -1 |awk '{if ($1=="OK") {ms=(substr($(NF-2),1)); printf ("OK\n",ms)} else {printf ("NOK\n",ms)};exit}')
  export TNSPING_STANDBY=$($ORACLE_HOME/bin/tnsping ${STANDBY} |tail -1 |awk '{if ($1=="OK") {ms=(substr($(NF-2),1)); printf ("OK\n",ms)} else {printf ("NOK\n",ms)};exit}')
  echo PRIMARY is set to value ${PRIMARY} "....." $TNSPING_PRIMARY  | tee -a $LOG
  echo STANDBY is set to value ${STANDBY} "....." $TNSPING_STANDBY  | tee -a $LOG


  if [ $TNSPING_PRIMARY = "OK" ] && [ $TNSPING_STANDBY = "OK" ] ; then
    echo TNSPING.........OK | tee -a $LOG
  else
    echo TNSPING.........NOK | tee -a $LOG
    exit 1
  fi

fi




if [ -e $ATK_ORACLE_MODULE_DATAGUARD_SCRIPT/$DBNAME/atkpw ] ; then
export CREDENCIAL=$(cat $ATK_ORACLE_MODULE_DATAGUARD_SCRIPT/$DBNAME/atkpw | grep "UP " | awk -F" " {'print$2'} | base64 -d )
export CONNECTION=$(echo   $CREDENCIAL"@""$PRIMARY" ' as sysdba')

echo ''
echo ''
echo ''
echo ''
echo '------------------------------------------------------'
echo ''
echo "CHECK Connect Database PRIMARY = " $PRIMARY
check_db
if [ "${DBNAME}" = "${v_DB_NAME}"  -a "${v_DATABASE_RULE}" = "PRIMARY" ] ; then
echo "CHECK Connect Database PRIMARY .................... OK"
export CONN_PRIMARY=$CONNECTION
export v_DGBROKER_PRIMARY=$v_DGBROKER
else
echo ''
echo "argument: --dbname "  $DBNAME
echo "db_name database : " $v_DB_NAME
echo "argument: --primary " $PRIMARY " this database has DATABASE_RULE " $v_DATABASE_RULE
echo ' --->   Check if the information is consistent '
echo ''
echo "CHECK Connect Database PRIMARY .................... NOK"
fi


##########################

export CREDENCIAL=$(cat $ATK_ORACLE_MODULE_DATAGUARD_SCRIPT/$DBNAME/atkpw | grep "UP " | awk -F" " {'print$2'} | base64 -d )
export CONNECTION=$(echo   $CREDENCIAL"@""$STANDBY" ' as sysdba')

if [ ${NOCHECK_STANDBY} = "OFF" ] ; then

echo ''
echo "CHECK Connect Database STANDBY = " $STANDBY
check_db
if [ "${DBNAME}" = "${v_DB_NAME}"  -a "${v_DATABASE_RULE}" = "PHYSICAL STANDBY" ] ; then
echo "CHECK Connect Database STANDBY .................... OK"
export CONN_STB=$CONNECTION
export v_DGBROKER_STANDBY=$v_DGBROKER
else
echo ''
echo "argument: --dbname "  $DBNAME
echo "db_name database : " $v_DB_NAME
echo "argument: --standby " $STANDBY " this database has DATABASE_RULE " $v_DATABASE_RULE
echo ' --->   Check if the information is consistent '
echo ''
echo "CHECK Connect Database STANDBY .................... NOK"
fi

fi 

echo ''
echo '------------------------------------------------------'
echo ''



else
echo ''
echo '------------------------------------------------------'
echo ''
echo "check if the dbname argument matches the value of the db_name parameter of the database instance."
echo "          --dbname = " $DBNAME
echo "          directory " $ATK_ORACLE_MODULE_DATAGUARD_SCRIPT/$DBNAME " does not exist"
echo ''
echo '------------------------------------------------------'
echo ''

exit 1
fi

echo $CONN_PRIMARY
echo $CONN_STB

if [ "${NOCHECK_STANDBY}" == "ON" ] ; then
export v_DGBROKER_STANDBY=$v_DGBROKER_PRIMARY
   echo "DGBROKER STANDBY = " $v_DGBROKER_STANDBY
   echo "DGBROKER PRIMARY = " $v_DGBROKER_PRIMARY
fi

if [ $v_DGBROKER_STANDBY = $v_DGBROKER_PRIMARY ] ; then
  export DGBROKER=$v_DGBROKER_STANDBY
  if [ $DGBROKER = "ENABLED" ] ; then
    echo "Dataguard Broker ....................... ENABLED"
    export DGBroker="ON"
  else
    echo "Dataguard Broker ....................... DISABLE"
    export DGBroker="OFF"
  fi
else
   echo "check if the information Dataguard Broker is consistent"
   echo "DGBROKER STANDBY = " $v_DGBROKER_STANDBY 
   echo "DGBROKER PRIMARY = " $v_DGBROKER_PRIMARY
fi


echo ''
echo '------------------------------------------------------'
echo ''


echo " ----> 1) CHECKLIST "
echo ''
echo "           Primary Database"
export CHECKLIST_PRIMARY_01=$(echo "SET HEAD OFF
   SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
   SELECT   CASE count(*) WHEN 0 THEN 'NOK' WHEN 1 THEN 'OK' ELSE 'OK' END FROM v\$database where protection_mode=protection_level and DATABASE_ROLE='PRIMARY'  ; 
   exit" | $ORACLE_HOME/bin/sqlplus -s $CONN_PRIMARY )

if [ $CHECKLIST_PRIMARY_01 = 'OK' ] ; then
echo "CHECKLIST PRIMARY - 1 ......................OK"
else
echo "CHECKLIST PRIMARY - 1 ......................NOK"
exit 1
fi

export CHECKLIST_PRIMARY_02=$(echo "SET HEAD OFF
   SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
   SELECT   CASE count(*) WHEN 0 THEN 'NOK' WHEN 1 THEN 'OK' ELSE 'OK' END FROM dba_registry where comp_id = 'CATPROC' and STATUS='VALID' ;
   exit" | $ORACLE_HOME/bin/sqlplus -s $CONN_PRIMARY )


if [ $CHECKLIST_PRIMARY_02 = 'OK' ] ; then
echo "CHECKLIST PRIMARY - 2 ......................OK"
else
echo "CHECKLIST PRIMARY - 2 ......................NOK"
exit 1
fi

export CHECKLIST_PRIMARY_03=$(echo "SET HEAD OFF
   SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
   SELECT   CASE count(*) WHEN 0 THEN 'OK' ELSE 'NOK' END FROM v\$dataguard_status where severity in ('Error','Fatal') and timestamp BETWEEN  (SYSTIMESTAMP  - (2/48)) and SYSTIMESTAMP  order by timestamp;
   exit" | $ORACLE_HOME/bin/sqlplus -s $CONN_PRIMARY )
   

if [ $CHECKLIST_PRIMARY_03 = 'OK' ] ; then
echo "CHECKLIST PRIMARY - 3 ......................OK"
else
echo "CHECKLIST PRIMARY - 3 ......................WARNING"
export WARNING='ON'
fi



export CHECKLIST_PRIMARY_04=$(echo "SET HEAD OFF
   SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
   @$ATK_ORACLE_MODULE_DATAGUARD_SCRIPT/gap.sql
   exit" | $ORACLE_HOME/bin/sqlplus -s $CONN_PRIMARY )


if [ $CHECKLIST_PRIMARY_04 = 'OK' ] ; then
echo "CHECKLIST PRIMARY - 4 ......................OK"
else
echo "CHECKLIST PRIMARY - 4 ......................WARNING"
export WARNING='ON'
fi



echo ''
echo "           STANDBY Database"
export CHECKLIST_STANDBY_01=$(echo "SET HEAD OFF
   SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
   SELECT   CASE count(*) WHEN 0 THEN 'NOK' WHEN 1 THEN 'OK' ELSE 'OK' END FROM v\$database where protection_mode=protection_level and DATABASE_ROLE='PHYSICAL STANDBY'  ;
   exit" | $ORACLE_HOME/bin/sqlplus -s $CONN_STB )

if [ ${NOCHECK_STANDBY} = "ON" ] ; then
echo "CHECKLIST STANDBY - 1 ......................IGNORE (SNAPSHOT STANDBY)"
else

 if [ $CHECKLIST_STANDBY_01 = 'OK' ] ; then
     echo "CHECKLIST STANDBY - 1 ......................OK"
 else
     echo "CHECKLIST STANDBY - 1 ......................NOK"
     exit 1
 fi

fi

export CHECKLIST_STANDBY_02=$(echo "SET HEAD OFF
   SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
   SELECT   CASE count(*) WHEN 0 THEN 'OK' ELSE 'NOK' END FROM v\$dataguard_status where severity in ('Error','Fatal') and timestamp BETWEEN  (SYSTIMESTAMP  - (2/48)) and SYSTIMESTAMP  order by timestamp;
   exit" | $ORACLE_HOME/bin/sqlplus -s $CONN_STB )


if [ ${NOCHECK_STANDBY} = "ON" ] ; then
echo "CHECKLIST STANDBY - 2 ......................IGNORE (SNAPSHOT STANDBY)"

else
   if [ $CHECKLIST_STANDBY_02 = 'OK' ] ; then
      echo "CHECKLIST STANDBY - 2 ......................OK"
   else
      echo "CHECKLIST STANDBY - 2 ......................WARNING"
      export WARNING='ON'
   fi
fi


if [ $DGBroker = "ON" ] ; then
export DGBROKER_CONNECT_STANDBY=$(echo dgmgrl $CONN_STB | awk -F"as" {'print$1'})
export DGBROKER_CONNECT_PRIMARY=$(echo dgmgrl $CONN_PRIMARY | awk -F"as" {'print$1'})
#echo $DGBROKER_CONNECT_STANDBY
#echo $DGBROKER_CONNECT_PRIMARY
else
exit 1
fi




result=$(echo "show configuration;" | $DGBROKER_CONNECT_PRIMARY | grep -i "Configuration Status" -A1 | tail -1)
if [ "$result" = "SUCCESS" ] ; then
   export BROKER_DBNAME_PRIMARY=$($DGBROKER_CONNECT_PRIMARY  "show configuration" | grep -i "Primary database" |    awk -F"-" -v q="'" {'print q$1q'} | sed 's/ //g')
#   echo $BROKER_DBNAME_PRIMARY
else
exit 1
fi


if [ ${NOCHECK_STANDBY} = "OFF" ] ; then

result=$(echo "show configuration;" | $DGBROKER_CONNECT_STANDBY | grep -i "Configuration Status" -A1 | tail -1)
if [ "$result" = "SUCCESS" ] ; then
export BROKER_DBNAME_STANDBY=$($DGBROKER_CONNECT_STANDBY  "show configuration" | grep -i "Physical standby database" |    awk -F"-" -v q="'" {'print q$1q'} | sed 's/ //g')
# echo $BROKER_DBNAME_STANDBY
else
exit 1
fi

fi



if [ $OPS = "chaveamento" ] ; then
echo "switchover to " $BROKER_DBNAME_STANDBY  
echo ''
echo $BROKER_DBNAME_PRIMARY " ---------> " $BROKER_DBNAME_STANDBY
echo ''
sleep 10
echo "switchover to " $BROKER_DBNAME_STANDBY  | $DGBROKER_CONNECT_PRIMARY
fi



if [ "$BOLHA" == "STANDBY" ] ; then

  result=$(echo "show configuration;" | $DGBROKER_CONNECT_PRIMARY | grep -i "Configuration Status" -A1 | tail -1)
  if [ "$result" = "SUCCESS" ] ; then
  export BROKER_DBNAME_STANDBY=$($DGBROKER_CONNECT_PRIMARY  "show configuration" | grep -i "Snapshot standby database" |    awk -F"-" -v q="'" {'print q$1q'} | sed 's/ //g')
  echo $BROKER_DBNAME_STANDBY
  else
  exit 1
  fi

fi


if [[ "$OPS" == "bolha" && "$BOLHA" == "STANDBY" ]]; then

export standby=$BROKER_DBNAME_STANDBY
echo '' ; echo '' ; echo ''
echo '------------------------------'
echo ''
echo "convert database " $standby " to physical standby; "
echo ''
echo "SNAPSHOT STANDBY  --->  PHYSICAL STANDBY"
echo ''
sleep 10
echo "convert database " $standby " to physical standby; " |  $DGBROKER_CONNECT_PRIMARY

fi

if [[ "$OPS" == "bolha" && "$BOLHA" == "SNAPSHOT" ]]; then

export standby=$BROKER_DBNAME_STANDBY
echo '' ; echo '' ; echo ''
echo '------------------------------'
echo ''
echo "convert database " $standby " to snapshot standby; "  
echo ''
echo "PHYSICAL STANDBY  --->  SNAPSHOT STANDBY"
echo ''
sleep 10
echo "convert database " $standby " to snapshot standby; "  | $DGBROKER_CONNECT_PRIMARY

fi






