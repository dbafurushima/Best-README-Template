


   #     #######  #    #         #####   #######  #     #  #######  ###   #####
  # #       #     #   #         #     #  #     #  ##    #  #         #   #     #
 #   #      #     #  #          #        #     #  # #   #  #         #   #
#     #     #     ###           #        #     #  #  #  #  #####     #   #  ####
#######     #     #  #          #        #     #  #   # #  #         #   #     #
#     #     #     #   #         #     #  #     #  #    ##  #         #   #     #
#     #     #     #    #         #####   #######  #     #  #        ###   #####


###########################################################################################


export ATK_HOME=/backup/tivit/atk
#### ATK Variable Environment Base
export ATK=${ATK_HOME}

#### ATK Basic Variable Environment - Oracle
export ATK_ORACLE=${ATK}/oracle
export ATK_ORACLE_TNS=${ATK_ORACLE_HOME}/network/admin

#### ATK Module HOME
export ATK_ORACLE_MODULE=${ATK_ORACLE}/module

#### ATK Modules Type
#### export ATK_ORACLE_MODULE_<MODULE-NAME>=${ATK_ORACLE_MODULE}/<MODULE-NAME>
#### export ATK_ORACLE_MODULE_<MODULE-NAME>_SCRIPT=${ATK_ORACLE_MODULE}/<MODULE-NAME>/script
export ATK_ORACLE_MODULE_REFRESH=${ATK_ORACLE_MODULE}/refresh
export ATK_ORACLE_MODULE_REFRESH_SCRIPT=${ATK_ORACLE_MODULE}/refresh/script

export ATK_ORACLE_MODULE_DATAGUARD=${ATK_ORACLE_MODULE}/dataguard
export ATK_ORACLE_MODULE_DATAGUARD_SCRIPT=${ATK_ORACLE_MODULE}/dataguard/script
