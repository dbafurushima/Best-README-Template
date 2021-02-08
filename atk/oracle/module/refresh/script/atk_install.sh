#!/bin/bash
echo '' > target_tns.txt
echo '' > source_tns.txt
echo '' > atkpw


cecho(){
    RED="\033[0;31m"
    GREEN="\033[0;32m"
    YELLOW="\033[1;33m"
    # ... ADD MORE COLORS
    NC="\033[0m" # No Color

    printf "${!1}${2} ${NC}\n"
}

is_empty() {
    local var_name="$1"
    local var_value="${!var_name}"
    if [[ -v "$var_name" ]]; then
       if [[ -n "$var_value" ]]; then
         echo "$var_name" =  "$var_value" "   ............... OK "
       else
         echo $var_name variable is not defined. Please repeat the execution!
         export is_compliance=FALSE
       fi
    else
       echo "unset"
    fi
}




cat banner ; echo '' ; sleep 1


echo ''
echo ''
for (( i=0;i<=10;i++))
do
echo -en "\033[1A"
echo -en "ANSWER INFORMATION QUESTIONS REGARDING SOURCE DATABASE.\n";
#sleep 0.5s;
echo -en "\033[1A"
echo -en "                                                            \n";
#sleep 0.5s;
done
echo -en "\033[2A"
echo -en "                                                            \n";
echo -en "\033[1A"
echo ''
echo ''
echo  -e "\033[33;7m SOURCE DATABASE - BANCO DE DADOS DE ORIGEM \033[0m"
echo ''
echo ''



##### ATK - HOME
read -p "Please Enter with ATK_HOME (location of ATK-OracleDatabase scripts) followed by ENTER: " v_ATK_HOME ; echo ''

##### ATK - ORACLE_HOME
read -p "Please Enter with ORACLE_HOME for the database that is involved in REFRESH followed by ENTER: " v_ATK_ORACLEHOME ; echo ''

##### ATK - IP SOURCE DATABASE
read -p "Please Enter with IP from the SOURCE database followed by ENTER: " v_ATK_IPDATABASE ; echo ''

##### ATK - PORT ORACLE LISTENER
v_ATK_PORTDB_default=1521
read -p "Please Enter with PORT from the SOURCE database followed by ENTER (default = 1521) : " v_ATK_PORTDB_install ; echo ''
v_ATK_PORTDB="${v_ATK_PORTDB_install:-$v_ATK_PORTDB_default}"
#echo $v_ATK_PORTDB

##### ATK - SERVICE_NAME by SOURCE
read -p "Please Enter with SERVICE_NAME from the SOURCE database followed by ENTER: " v_ATK_SERVICENAME ; echo ''


echo ''
echo '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
is_empty v_ATK_HOME
is_empty v_ATK_ORACLEHOME
is_empty v_ATK_IPDATABASE
is_empty v_ATK_PORTDB
is_empty v_ATK_SERVICENAME
echo '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
echo ''



if [ -n "$is_compliance" ]; then
   echo ''
   echo  -e "\033[33;7m "You did not enter all the necessary information, repeat the execution!" \033[0m"
   echo ''
   exit

else
export SOURCE_ATKHOME=$v_ATK_HOME
export SOURCE_ORACLEHOME=$v_ATK_ORACLEHOME
export SOURCE_IP=$v_ATK_IPDATABASE
export SOURCE_PORTLISTENER=$v_ATK_PORTDB
export SOURCE_SERVICENAME=$v_ATK_SERVICENAME
    echo '' ; cecho "GREEN" "SOURCE DATABASE ............. OK"  ; echo ''

unset v_ATK_HOME v_ATK_ORACLEHOME v_ATK_IPDATABASE v_ATK_PORTDB v_ATK_SERVICENAME is_compliance
fi


echo '' > atk_source.sh
cat  banner_atk_config >> atk_source.sh
echo export 'ATK_HOME='$SOURCE_ATKHOME  >> atk_source.sh
cat template_atk_config.txt >> atk_source.sh




echo ''
###############################################################
echo ''


echo ''
echo ''
for (( i=0;i<=10;i++))
do
echo -en "\033[1A"
echo -en "ANSWER INFORMATION QUESTIONS REGARDING TARGET DATABASE.\n";
#sleep 0.5s;
echo -en "\033[1A"
echo -en "                                                            \n";
#sleep 0.5s;
done
echo -en "\033[2A"
echo -en "                                                            \n";
echo -en "\033[1A"
echo ''
echo ''
echo  -e "\033[33;7m TARGET DATABASE - BANCO DE DADOS DE DESTINO \033[0m"
echo ''
echo ''



##### ATK - HOME
read -p "Please Enter with ATK_HOME (location of ATK-OracleDatabase scripts) followed by ENTER: " v_ATK_HOME ; echo ''

##### ATK - ORACLE_HOME
read -p "Please Enter with ORACLE_HOME for the database that is involved in REFRESH followed by ENTER: " v_ATK_ORACLEHOME ; echo ''

##### ATK - IP SOURCE DATABASE
read -p "Please Enter with IP from the SOURCE database followed by ENTER: " v_ATK_IPDATABASE ; echo ''

##### ATK - PORT ORACLE LISTENER
v_ATK_PORTDB_default=1521
read -p "Please Enter with PORT from the SOURCE database followed by ENTER (default = 1521) : " v_ATK_PORTDB_install ; echo ''
v_ATK_PORTDB="${v_ATK_PORTDB_install:-$v_ATK_PORTDB_default}"
#echo $v_ATK_PORTDB

##### ATK - SERVICE_NAME by SOURCE
read -p "Please Enter with SERVICE_NAME from the SOURCE database followed by ENTER: " v_ATK_SERVICENAME ; echo ''

echo ''
echo '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
is_empty v_ATK_HOME
is_empty v_ATK_ORACLEHOME
is_empty v_ATK_IPDATABASE
is_empty v_ATK_PORTDB
is_empty v_ATK_SERVICENAME
echo '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
echo ''



if [ -n "$is_compliance" ]; then
   echo ''
   echo  -e "\033[33;7m "You did not enter all the necessary information, repeat the execution!" \033[0m"
   echo ''
   exit

else
export TARGET_ATKHOME=$v_ATK_HOME
export TARGET_ORACLEHOME=$v_ATK_ORACLEHOME
export TARGET_IP=$v_ATK_IPDATABASE
export TARGET_PORTLISTENER=$v_ATK_PORTDB
export TARGET_SERVICENAME=$v_ATK_SERVICENAME
    echo '' ; cecho "GREEN" "TARGET DATABASE ............. OK"  ; echo ''

unset v_ATK_HOME v_ATK_ORACLEHOME v_ATK_IPDATABASE v_ATK_PORTDB v_ATK_SERVICENAME is_compliance
fi

echo '' > atk_target.sh
cat  banner_atk_config >> atk_target.sh
echo export 'ATK_HOME='$SOURCE_ATKHOME  >> atk_target.sh
cat template_atk_config.txt >> atk_target.sh




###################################################################


echo '' ; echo ''; echo ''
echo "At this point, you must enter a username and password that has SYSDBA permission. It is recommended to use the SYS user." ; echo ''


v_USERORACLE_default="sys"
echo -n "username (DEFAULT = sys):" ; read username_install
username="${username_install:-$v_USERORACLE_default}"

echo ''

    v_PASSWORD=1
while [ $v_PASSWORD -eq 1 ]; do
read -s -p "Enter Password: " password1 ; echo ''
read -s -p "Re-enter Password: " password2 ; echo ''

if [ "$password1" = "$password2" ]; then
export PASSWORD_ORACLEDB=$(echo $password1 | base64)
echo UP $PASSWORD_ORACLEDB | tee -a atkpw
    v_PASSWORD=0
    echo '' ; cecho "GREEN" "MATCH password ..... OK"  ; echo ''
else
    echo '' ; cecho "RED" "Divergent Password ..... NOK"  ; echo ''
    v_PASSWORD=1
fi

done





###################################################################


echo ''
echo '================================================================================='
echo ' Siga as instrucoes abaixo '

echo ''
echo ' 1. Inclua as strings de conexoes no tnsnames.ora utilizado pelo seu ambiente RDBMS, SOURCE e TARGET '
echo '    - Comumente no tnsnames.ora fica localizado em $ORACLE_HOME/network/admin/tnsnames.ora '
echo '    - Caso esteja em outro local, verificar a variavel de ambiente TNS_ADMIN '
echo ''
export HOST_ADDR=$SOURCE_IP
export PORT_NUM=$SOURCE_PORTLISTENER
export SRV_NAME=$SOURCE_SERVICENAME
export TNS_ADMIN_DIR=$SOURCE_ORACLEHOME/network/admin
export ENTRY_NAME=SOURCE

echo "
$ENTRY_NAME =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = $HOST_ADDR)(PORT = $PORT_NUM))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = $SRV_NAME)
    )
  )
" | tee -a source_tns.txt

echo ''
echo ' --> O conteudo tambem consta no arquivo source_tns.txt, neste diretorio corrente.'
echo ''


export HOST_ADDR=$TARGET_IP
export PORT_NUM=$TARGET_PORTLISTENER
export SRV_NAME=$TARGET_SERVICENAME
export TNS_ADMIN_DIR=$TARGET_ORACLEHOME/network/admin
export ENTRY_NAME=TARGET

echo "
$ENTRY_NAME =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = $HOST_ADDR)(PORT = $PORT_NUM))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = $SRV_NAME)
    )
  )
" | tee -a target_tns.txt


echo ''
echo ' --> O conteudo tambem consta no arquivo target_tns.txt, neste diretorio corrente.'
echo ''


echo ' 2. Utilizando o usuario ROOT, faca a copia dos arquivos bash para padronizacao das "set environment variables", veja os detalhes abaixo :'
echo '    - No ambiente SOURCE, copie o arquivo atk_source.sh para /etc/profile.d '
echo '    - No ambiente TARGET, copie o arquivo atk_target.sh para /etc/profile.d '
echo ''
echo "######### SOURCE"
echo "            [root@SOURCE-DATABASE atk]#" cp atk_source.sh /etc/profile.d/
echo ''
echo "######### TARGET"
echo "            [root@TARGET-DATABASE atk]#" cp atk_source.sh /etc/profile.d/
echo '' ; echo ''

