source $ATK_HOME/conf/atk.conf
env | grep -i atk | egrep -iv "OLDPWD=|PWD=|TNS_ADMIN=|LOG=" | awk -F"=" {'print $2'} | sort | uniq | xargs mkdir -p 
env | grep -i atk | egrep -iv "PWD=|OLDPWD=" | sort| uniq

