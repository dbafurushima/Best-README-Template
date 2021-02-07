run {
allocate channel PRIMARY_channel_01 type disk;
allocate channel PRIMARY_channel_02 type disk;
allocate channel PRIMARY_channel_03 type disk;
allocate channel PRIMARY_channel_04 type disk;
allocate channel PRIMARY_channel_05 type disk;
allocate channel PRIMARY_channel_06 type disk;
allocate channel PRIMARY_channel_07 type disk;
allocate channel PRIMARY_channel_08 type disk;
allocate channel PRIMARY_channel_09 type disk;
allocate channel PRIMARY_channel_10 type disk;
allocate channel PRIMARY_channel_11 type disk;
allocate channel PRIMARY_channel_12 type disk;
allocate channel PRIMARY_channel_13 type disk;
allocate channel PRIMARY_channel_14 type disk;
allocate channel PRIMARY_channel_15 type disk;
allocate channel PRIMARY_channel_16 type disk;
allocate channel PRIMARY_channel_17 type disk;
allocate channel PRIMARY_channel_18 type disk;
allocate channel PRIMARY_channel_19 type disk;
allocate channel PRIMARY_channel_20 type disk;
allocate channel PRIMARY_channel_21 type disk;
allocate channel PRIMARY_channel_22 type disk;
allocate channel PRIMARY_channel_23 type disk;
allocate channel PRIMARY_channel_24 type disk;
allocate channel PRIMARY_channel_25 type disk;
allocate channel PRIMARY_channel_26 type disk;
allocate channel PRIMARY_channel_27 type disk;
allocate channel PRIMARY_channel_28 type disk;
allocate channel PRIMARY_channel_29 type disk;
allocate channel PRIMARY_channel_30 type disk;
allocate channel PRIMARY_channel_31 type disk;
allocate channel PRIMARY_channel_32 type disk;
allocate channel PRIMARY_channel_33 type disk;
allocate channel PRIMARY_channel_34 type disk;
allocate channel PRIMARY_channel_35 type disk;
allocate channel PRIMARY_channel_36 type disk;
allocate channel PRIMARY_channel_37 type disk;
allocate channel PRIMARY_channel_38 type disk;
allocate channel PRIMARY_channel_39 type disk;
allocate channel PRIMARY_channel_40 type disk;
allocate channel PRIMARY_channel_41 type disk;
allocate channel PRIMARY_channel_42 type disk;
allocate channel PRIMARY_channel_43 type disk;
allocate channel PRIMARY_channel_44 type disk;
allocate channel PRIMARY_channel_45 type disk;
allocate channel PRIMARY_channel_46 type disk;
allocate channel PRIMARY_channel_47 type disk;
allocate channel PRIMARY_channel_48 type disk;
allocate channel PRIMARY_channel_49 type disk;
allocate channel PRIMARY_channel_50 type disk;
allocate channel PRIMARY_channel_51 type disk;
allocate channel PRIMARY_channel_52 type disk;
allocate channel PRIMARY_channel_53 type disk;
allocate channel PRIMARY_channel_54 type disk;
allocate channel PRIMARY_channel_55 type disk;
allocate channel PRIMARY_channel_56 type disk;
allocate channel PRIMARY_channel_57 type disk;
allocate channel PRIMARY_channel_58 type disk;
allocate channel PRIMARY_channel_59 type disk;
allocate channel PRIMARY_channel_60 type disk;
allocate channel PRIMARY_channel_61 type disk;
allocate channel PRIMARY_channel_62 type disk;
allocate channel PRIMARY_channel_63 type disk;
allocate channel PRIMARY_channel_64 type disk;
allocate channel PRIMARY_channel_65 type disk;
allocate channel PRIMARY_channel_66 type disk;
allocate channel PRIMARY_channel_67 type disk;
allocate channel PRIMARY_channel_68 type disk;
allocate channel PRIMARY_channel_69 type disk;
allocate channel PRIMARY_channel_70 type disk;
allocate channel PRIMARY_channel_71 type disk;
allocate channel PRIMARY_channel_72 type disk;
allocate channel PRIMARY_channel_73 type disk;
allocate channel PRIMARY_channel_74 type disk;
allocate channel PRIMARY_channel_75 type disk;
allocate channel PRIMARY_channel_76 type disk;
allocate channel PRIMARY_channel_77 type disk;
allocate channel PRIMARY_channel_78 type disk;
allocate channel PRIMARY_channel_79 type disk;
allocate channel PRIMARY_channel_80 type disk;
allocate channel PRIMARY_channel_81 type disk;
allocate channel PRIMARY_channel_82 type disk;
allocate channel PRIMARY_channel_83 type disk;
allocate channel PRIMARY_channel_84 type disk;
allocate channel PRIMARY_channel_85 type disk;
allocate channel PRIMARY_channel_86 type disk;
allocate channel PRIMARY_channel_87 type disk;
allocate channel PRIMARY_channel_88 type disk;
allocate channel PRIMARY_channel_89 type disk;
allocate channel PRIMARY_channel_90 type disk;
allocate channel PRIMARY_channel_91 type disk;
allocate channel PRIMARY_channel_92 type disk;
allocate channel PRIMARY_channel_93 type disk;
allocate channel PRIMARY_channel_94 type disk;
allocate channel PRIMARY_channel_95 type disk;
allocate channel PRIMARY_channel_96 type disk;
allocate channel PRIMARY_channel_97 type disk;
allocate channel PRIMARY_channel_98 type disk;
allocate channel PRIMARY_channel_99 type disk;
allocate channel PRIMARY_channel_100 type disk;
allocate channel PRIMARY_channel_101 type disk;
allocate channel PRIMARY_channel_102 type disk;
allocate channel PRIMARY_channel_103 type disk;
allocate channel PRIMARY_channel_104 type disk;
allocate channel PRIMARY_channel_105 type disk;
allocate channel PRIMARY_channel_106 type disk;
allocate channel PRIMARY_channel_107 type disk;
allocate channel PRIMARY_channel_108 type disk;
allocate channel PRIMARY_channel_109 type disk;
allocate channel PRIMARY_channel_110 type disk;
allocate channel PRIMARY_channel_111 type disk;
allocate channel PRIMARY_channel_112 type disk;
allocate channel PRIMARY_channel_113 type disk;
allocate channel PRIMARY_channel_114 type disk;
allocate channel PRIMARY_channel_115 type disk;
allocate channel PRIMARY_channel_116 type disk;
allocate channel PRIMARY_channel_117 type disk;
allocate channel PRIMARY_channel_118 type disk;
allocate channel PRIMARY_channel_119 type disk;
allocate channel PRIMARY_channel_120 type disk;
allocate auxiliary channel STANDBT_channel_01 type disk;
allocate auxiliary channel STANDBT_channel_02 type disk;
allocate auxiliary channel STANDBT_channel_03 type disk;
allocate auxiliary channel STANDBT_channel_04 type disk;
allocate auxiliary channel STANDBT_channel_05 type disk;
allocate auxiliary channel STANDBT_channel_06 type disk;
allocate auxiliary channel STANDBT_channel_07 type disk;
allocate auxiliary channel STANDBT_channel_08 type disk;
allocate auxiliary channel STANDBT_channel_09 type disk;
allocate auxiliary channel STANDBT_channel_10 type disk;
SET NEWNAME FOR DATABASE TO NEW ;
duplicate target database to issdes from active  database
SPFILE
  PARAMETER_VALUE_CONVERT 'ISSP','issdes','ISSPSTB','issdes'
  SET CONTROL_FILES='+DATAC1'
  SET DB_CREATE_FILE_DEST='+DATAC1'
  SET DB_RECOVERY_FILE_DEST_SIZE='500G'
  SET AUDIT_FILE_DEST='/u01/app/oracle/admin/issdes/adump'
  SET SGA_TARGET='25G'
  SET SGA_MAX_SIZE='25G'
  SET SHARED_POOL_SIZE='7G'
  SET DB_CACHE_SIZE='10G'
  SET CLUSTER_DATABASE='FALSE'
  SET DG_BROKER_CONFIG_FILE1=' '
  SET DG_BROKER_CONFIG_FILE2=' '
  SET UNDO_TABLESPACE='UNDOTBS1'
  SET DG_BROKER_START='FALSE'
  SET remote_listener=''
  SET service_names='ISSDES' 
  SET db_recovery_file_dest=''
  SET log_archive_dest_1='location=+DBFS_DG'
logfile
      GROUP 1  ('+RECOC1') SIZE 5G
     ,GROUP 2  ('+RECOC1') SIZE 5G
     ,GROUP 3  ('+RECOC1') SIZE 5G
     ,GROUP 4  ('+RECOC1') SIZE 5G
     ,GROUP 5  ('+RECOC1') SIZE 5G
     ,GROUP 6  ('+RECOC1') SIZE 5G
     ,GROUP 7  ('+RECOC1') SIZE 5G
     ,GROUP 8  ('+RECOC1') SIZE 5G
     ,GROUP 9  ('+RECOC1') SIZE 5G
     ,GROUP 10 ('+RECOC1') SIZE 5G;
}

