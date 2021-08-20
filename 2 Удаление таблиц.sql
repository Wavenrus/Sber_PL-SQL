--Удаление ограничений и таблиц
ALTER TABLE CLIENT
	DROP PRIMARY KEY CASCADE;

ALTER TABLE PLAN_OPER
	DROP CONSTRAINT P_COLLECTION_ID_fk;

ALTER TABLE FACT_OPER
	DROP CONSTRAINT F_COLLECTION_ID_fk;

ALTER TABLE pr_cred
	DROP PRIMARY KEY CASCADE;
		
ALTER TABLE pr_cred
	DROP UNIQUE (COLLECT_PLAN);
		
ALTER TABLE pr_cred
	DROP UNIQUE (COLLECT_FACT);
	
drop TABLE PR_CRED;
    
drop TABLE CLIENT;

drop TABLE PLAN_OPER;

drop TABLE FACT_OPER;

drop TABLE ImpCLIENT;

drop TABLE ImpFACT_OPER;

drop TABLE ImpPr_cred;

drop TABLE ImpPLAN_OPER;

drop function func_pr_cred_report;

drop type t_pr_cred_report_table;

drop type t_pr_cred_report;