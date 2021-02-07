. ~oracle/.bash_profile > /dev/null
. $ATK_HOME/conf/create_atk_dirs.sh > /dev/null
. $ATK_ORACLE_MODULE_REFRESH_SCRIPT/setoraenv.sh > /dev/null

export ORACLE_SID=$1

export PFILE_VAR=$ATK_ORACLE_MODULE_REFRESH_SCRIPT

/bin/rm $ATK_ORACLE_MODULE_REFRESH_SCRIPT/pfile_drop

sqlplus / as sysdba << EOF
create pfile='$PFILE_VAR/pfile_drop' from memory ;
select ' drop database ' from dual ;
shutdown abort ;
startup mount restrict pfile=$ATK_ORACLE_MODULE_REFRESH_SCRIPT/pfile_drop
alter database flashback off ;
ALTER DATABASE DISABLE BLOCK CHANGE TRACKING;
drop database;
EOF

sqlplus / as sysdba << EOF
shutdown abort ;
startup nomount pfile=$ATK_ORACLE_MODULE_REFRESH_SCRIPT/pfile_duplicate
EOF



