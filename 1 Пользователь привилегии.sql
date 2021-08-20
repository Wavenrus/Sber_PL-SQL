alter session set "_ORACLE_SCRIPT"=true;
CREATE USER sbr1 identified by pass;
grant create session to sbr1;
grant create table to sbr1;
grant create procedure to sbr1;
grant create trigger to sbr1;
grant create view to sbr1;
grant create sequence to sbr1;
grant alter any table to sbr1;
grant alter any procedure to sbr1;
grant alter any trigger to sbr1;
grant alter profile to sbr1;
grant delete any table to sbr1;
grant drop any table to sbr1;
grant drop any procedure to sbr1;
grant drop any trigger to sbr1;
grant drop any view to sbr1;
grant drop profile to sbr1;

grant select on sys.v_$session to sbr1;
grant select on sys.v_$sesstat to sbr1;
grant select on sys.v_$statname to sbr1;
grant SELECT ANY DICTIONARY to sbr1;
grant read,write on directory lang_external to sbr1;
ALTER USER sbr1 quota unlimited on users;

grant 
     EXECUTE ANY TYPE 
    ,CREATE ANY TYPE
    ,ALTER ANY TYPE
to sbr1;