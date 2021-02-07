
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

