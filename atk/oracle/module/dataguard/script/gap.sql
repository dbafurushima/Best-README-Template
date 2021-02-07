SELECT   CASE max(ARC_DIFF) WHEN 0 THEN 'OK' WHEN 1 THEN 'OK' ELSE 'NOK' END FROM 
(SELECT b.last_seq - a.applied_seq ARC_DIFF 
FROM   (SELECT thread#, 
               Max(sequence#) applied_seq, 
               Max(next_time) last_app_timestamp 
        FROM   gv$archived_log 
        WHERE  applied = 'YES' and resetlogs_change# in (select max(resetlogs_change#)  from gv$archived_log)
        GROUP  BY thread#) a, 
       (SELECT thread#, 
               Max (sequence#) last_seq 
        FROM   gv$archived_log where   resetlogs_change# in (select max(resetlogs_change#)  from gv$archived_log)
        GROUP  BY thread#) b 
WHERE  a.thread# = b.thread#) ;
exit
