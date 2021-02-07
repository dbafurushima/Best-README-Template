SET ECHO ON;
alter system checkpoint ;
alter system checkpoint ;
select 1 from dual;
alter system checkpoint ;
@/stage/issdes/pos/00_refresh_issdes.sql
alter system checkpoint ;
exit;
