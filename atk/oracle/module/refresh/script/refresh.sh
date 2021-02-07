#!/bin/bash
echo''
echo "Automation Tool Kit - atk"
echo ''



export LOG_DIR=$ATK_ORACLE_MODULE_REFRESH_SCRIPT/log
export LOG=$LOG_DIR/refresh.log

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

if [ -d $LOG_DIR ]; then
  LogRotate $LOG 10
else
  echo "Criando LOG_DIR: $LOG_DIR"
  mkdir -p $LOG_DIR
fi


# echo '' > $LOG



. ~oracle/.bash_profile > /dev/null
. $ATK_HOME/conf/create_atk_dirs.sh > /dev/null
. $ATK_ORACLE_MODULE_REFRESH_SCRIPT/setoraenv.sh > /dev/null

decode () {
  echo "$1" | base64 -d ; echo
}

export TNS_ADMIN=${ATK_ORACLE_TNS}

function check_db {
#  CONNECTION=$1
  RETVAL=`sqlplus -silent $CONNECTION <<EOF
SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
select 'Alive' from dual ;
EXIT;
EOF`



  if [ "$RETVAL" = "Alive" ]; then
    DB_OK=0
    echo "TEST DB CONNECT" $TNS_CONNECT ".........OK"
    echo "TEST DB CONNECT" $TNS_CONNECT ".........OK" |tee -a $LOG
    export v_HOSTNAME=$(echo "SET HEAD OFF
      set feedback off verify off heading off pagesize 0
      select HOST_NAME from v\$instance ;
        exit" | $ORACLE_HOME/bin/sqlplus -silent $CONNECTION )
export v_INSTANCE=$(echo "SET HEAD OFF
        set feedback off verify off heading off pagesize 0
        select INSTANCE_NAME from v\$instance ;
        exit" | $ORACLE_HOME/bin/sqlplus -silent $CONNECTION )

  else
    DB_OK=1
    echo "TEST DB CONNECT" $TNS_CONNECT ".........NOK"
    echo "TEST DB CONNECT" $TNS_CONNECT ".........NOK" |tee -a $LOG
    exit 1
  fi
}


function drop_database {
#  CONNECTION=$1
  RETVAL=`sqlplus -silent $CONNECTION <<EOF
SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
SELECT 'Alive' FROM dual;
EXIT;
EOF`

  if [ "$RETVAL" = "Alive" ]; then
    DB_OK=0
    echo "TEST DB CONNECT" $TNS_CONNECT ".........OK"
    echo "TEST DB CONNECT" $TNS_CONNECT ".........OK" |tee -a $LOG
  else
    DB_OK=1
    echo "TEST DB CONNECT" $TNS_CONNECT ".........NOK"
    echo "TEST DB CONNECT" $TNS_CONNECT ".........NOK" |tee -a $LOG
    exit 1
  fi
}




for i in "$@"
do
case $i in
    -t=*|--target=*)
    TARGET="${i#*=}"
    ;;
    -s=*|--source=*)
    SOURCE="${i#*=}"
    ;;
    -l=*|--lib=*)
    DIR="${i#*=}"
    ;;
    --default)
    DEFAULT=YES
    ;;
    *)
            # unknown option
    ;;
esac
done


if [ -z "$TARGET" ] || [ -z "$SOURCE" ] ; then

  echo 'one or more variables are undefined' |tee -a $LOG
  echo SOURCE is set to value ${SOURCE} |tee -a $LOG
  echo TARGET is set to value ${TARGET} |tee -a $LOG
  echo ENV.........NOK |tee -a $LOG

  exit 1

else
  export TNSPING_SOURCE=$($ORACLE_HOME/bin/tnsping ${SOURCE} |tail -1 |awk '{if ($1=="OK") {ms=(substr($(NF-2),1)); printf ("OK\n",ms)} else {printf ("NOK\n",ms)};exit}')
  export TNSPING_TARGET=$($ORACLE_HOME/bin/tnsping ${TARGET} |tail -1 |awk '{if ($1=="OK") {ms=(substr($(NF-2),1)); printf ("OK\n",ms)} else {printf ("NOK\n",ms)};exit}')
  echo SOURCE is set to value ${SOURCE} "....." $TNSPING_SOURCE >> $LOG
  echo TARGET is set to value ${TARGET} "....." $TNSPING_TARGET >> $LOG

  echo SOURCE is set to value ${SOURCE} "....." $TNSPING_SOURCE
  echo TARGET is set to value ${TARGET} "....." $TNSPING_TARGET

  if [ $TNSPING_SOURCE = "OK" ] && [ $TNSPING_TARGET = "OK" ] ; then
    echo TNSPING.........OK >> $LOG
    echo TNSPING.........OK
  else
    echo TNSPING.........NOK >> $LOG
    echo TNSPING.........NOK
    exit 2
  fi

fi

echo ''

if [ -e $ATK_ORACLE_MODULE_REFRESH_SCRIPT/atkpw ] && [ -r $ATK_ORACLE_MODULE_REFRESH_SCRIPT/atkpw ]  ; then
  echo ATKPW.........OK >> $LOG
  echo ATKPW.........OK
  export CREDENCIAL=$(cat $ATK_ORACLE_MODULE_REFRESH_SCRIPT/atkpw | grep "UP " | awk -F" " {'print$2'} | base64 -d )

  ##### TEST DBCONNECT
  export CONNECTION=$(echo   $CREDENCIAL"@""$SOURCE" ' as sysdba')
  export TNS_CONNECT=$SOURCE
  check_db
  export HOSTNAME_SOURCE=${v_HOSTNAME}
  export INSTANCE_SOURCE=${v_INSTANCE}

  echo "SOURCE (" ${SOURCE} ") is running on " $HOSTNAME_SOURCE  " on instance " ${INSTANCE_SOURCE}
  echo "SOURCE (" ${SOURCE} ") is running on " $HOSTNAME_SOURCE  " on instance " ${INSTANCE_SOURCE}  >> $LOG


  export CONNECTION=$(echo   $CREDENCIAL"@""$TARGET" ' as sysdba')
  export TNS_CONNECT=$TARGET
  check_db
  export HOSTNAME_TARGET=${v_HOSTNAME}
  export INSTANCE_TARGET=${v_INSTANCE}
  echo "TARGET (" ${TARGET} ") is running on " $HOSTNAME_TARGET  " on instance " ${INSTANCE_TARGET}
  echo "TARGET (" ${TARGET} ") is running on " $HOSTNAME_TARGET  " on instance " ${INSTANCE_TARGET}  >> $LOG

else
  echo ATK File Password not exist or not have permission
  echo ATKPW.........NOK
  exit 1
fi

echo ''
echo ''
echo ''
echo ' --------- LOG STOP/DROP Instance ---------' 
echo '' 
echo ''

ssh -o BatchMode=yes \
 -o "ConnectTimeout 3" \
 -o "StrictHostKeyChecking no" \
 -o "UserKnownHostsFile /dev/null"  \
 oracle@${HOSTNAME_TARGET} "$ATK_ORACLE_MODULE_REFRESH_SCRIPT/stopdatabase.sh ${INSTANCE_TARGET}" 
ERR=$?

if [ "$ERR" != "0" ]; then
  echo "exit $ERR"
fi

. $ATK_HOME/conf/create_atk_dirs.sh > /dev/null
. $ATK_ORACLE_MODULE_REFRESH_SCRIPT/setoraenv.sh > /dev/null

echo '' >> $LOG
echo '' >> $LOG
echo ' --------- LOG STOP/DROP Instance ---------' |tee -a $LOG
echo '' >> $LOG
echo '' >> $LOG
echo '' >> $LOG
echo '' >> $LOG
echo '' >> $LOG
echo '' >> $LOG
echo ' --------- LOG DUPLICATE ---------' |tee -a $LOG
echo '' >> $LOG
echo '' >> $LOG

$ORACLE_HOME/bin/rman target ${CREDENCIAL}@${SOURCE} auxiliary   ${CREDENCIAL}@${TARGET} cmdfile=$ATK_ORACLE_MODULE_REFRESH_SCRIPT/duplicate.rman |tee -a $LOG 

echo '' >> $LOG
echo '' >> $LOG
echo '' >> $LOG
echo '' >> $LOG
echo ' --------- LOG DUPLICATE ---------' |tee -a $LOG
echo '' >> $LOG
echo '' >> $LOG

# /stage/issdes/pos

ssh -o BatchMode=yes \
 -o "ConnectTimeout 3" \
 -o "StrictHostKeyChecking no" \
 -o "UserKnownHostsFile /dev/null"  \
 oracle@${HOSTNAME_TARGET} "$ATK_ORACLE_MODULE_REFRESH_SCRIPT/posrefresh.sh ${INSTANCE_TARGET}"
ERR=$?

if [ "$ERR" != "0" ]; then
  echo "exit $ERR"
fi


echo SOURCE = ${SOURCE}
echo TARGET = ${TARGET}
#echo DIRS = ${DIR}
#echo DEFAULT = ${DEFAULT}

