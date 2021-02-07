. ~oracle/.bash_profile > /dev/null
. $ATK_HOME/conf/create_atk_dirs.sh > /dev/null
. $ATK_ORACLE_MODULE_REFRESH_SCRIPT/setoraenv.sh > /dev/null

export ORACLE_SID=$1

cd /stage/issdes/pos/
pwd


sqlplus  / as sysdba @$ATK_ORACLE_MODULE_REFRESH_SCRIPT/posrefresh.sql

cd -


sqlplus -S / as sysdba <<EOF
SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO ON
alter system register ;
shutdown immediate ;
startup mount ;
alter database noarchivelog ;
alter database open ;
alter system register ;
EOF



export IP=$(srvctl config vip -n $(hostname | awk -F"." {'print$1'})  | awk -F"/" {'print$3'})
echo " alter system set local_listener='(ADDRESS=(PROTOCOL=TCP)(HOST="$IP")(PORT=1521))' ; " > $ATK_ORACLE_MODULE_REFRESH_SCRIPT/local_listener.sql
cat $ATK_ORACLE_MODULE_REFRESH_SCRIPT/local_listener.sql

sqlplus / as sysdba <<EOF
set echo on
set time on
set timing on
@$ATK_ORACLE_MODULE_REFRESH_SCRIPT/local_listener.sql
alter system checkpoint ;
alter system checkpoint ;
EOF


