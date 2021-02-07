unset ORACLE_SID
export GRID_HOME=$(cat /etc/oracle/olr.loc | grep -i crs_home | awk -F"=" {'print$2'})
export ORACLE_HOME=/u01/app/oracle/product/11.2.0.4/dbhome_1
export PATH=/usr/sbin:$PATH
export PATH=$ORACLE_HOME/OPatch:$ORACLE_HOME/OPatch/ocm/bin:$ORACLE_HOME/bin:$GRID_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib:/usr/local/lib:$ORACLE_HOME/lib32:/lib64:/usr/lib64:/usr/local/lib64
export LIBPATH=$LD_LIBRARY_PATH
