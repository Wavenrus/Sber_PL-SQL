-- Создание таблиц
	
drop TABLE PR_CRED;
 
CREATE TABLE PR_CRED 
    ( ID            NUMBER(15)
    , NUM_DOG       VARCHAR2(10)	CONSTRAINT pr_cred_num_dog_nn  NOT NULL
    , SUMMA_DOG     NUMBER(10,2)
    , DATE_BEGIN    DATE			CONSTRAINT pr_cred_d_begin_nn  NOT NULL
    , DATE_END      DATE			CONSTRAINT pr_cred_d_begin_nn  NOT NULL
    , ID_CLIENT     NUMBER(15)		CONSTRAINT pr_cred_id_client_nn  NOT NULL
    , COLLECT_PLAN  NUMBER(15)
    , COLLECT_FACT  NUMBER(15)
    );

drop TABLE CLIENT;

CREATE TABLE CLIENT 
    ( ID            NUMBER(15)
    , CL_NAME       VARCHAR2(200) 	CONSTRAINT client_name_nn  NOT NULL
    , DATE_BIRTH    DATE 			CONSTRAINT client_d_birth_nn  NOT NULL
    );

drop TABLE PLAN_OPER;

CREATE TABLE PLAN_OPER 
    ( COLLECTION_ID NUMBER(15)		CONSTRAINT pl_oper_id_nn  NOT NULL
    , P_DATE    DATE				CONSTRAINT pl_p_date_nn  NOT NULL
    , P_SUMMA     NUMBER(10,2)		CONSTRAINT pl_p_summa_nn  NOT NULL
    , TYPE_OPER     VARCHAR2(200)	CONSTRAINT pl_type_oper_nn  NOT NULL
    );

drop TABLE FACT_OPER;

CREATE TABLE FACT_OPER 
    ( COLLECTION_ID NUMBER(15)		CONSTRAINT fa_oper_id_nn  NOT NULL
    , F_DATE    DATE				CONSTRAINT fa_f_date_nn  NOT NULL
    , F_SUMMA     NUMBER(10,2)		CONSTRAINT fa_f_summa_nn  NOT NULL
    , TYPE_OPER     VARCHAR2(200)	CONSTRAINT fa_type_oper_nn  NOT NULL
    );
  
--Создание ограничений
ALTER TABLE CLIENT
    ADD ( CONSTRAINT     client_id_pk
                           PRIMARY KEY (id)
        );

ALTER TABLE pr_cred
    ADD ( CONSTRAINT     pr_ID_pk
                           PRIMARY KEY (ID)
        , CONSTRAINT     pr_plan_id_uk  UNIQUE (COLLECT_PLAN)
        , CONSTRAINT     pr_fact_id_uk  UNIQUE (COLLECT_FACT)
        , CONSTRAINT     pr_client_id_fk
                           FOREIGN KEY (ID_CLIENT)
                             REFERENCES CLIENT (ID)
        );
		
ALTER TABLE PLAN_OPER
    ADD ( CONSTRAINT     P_COLLECTION_ID_fk
                           FOREIGN KEY (COLLECTION_ID)
                             REFERENCES pr_cred (COLLECT_PLAN)
        );

ALTER TABLE FACT_OPER
    ADD ( CONSTRAINT     F_COLLECTION_ID_fk
                           FOREIGN KEY (COLLECTION_ID)
                             REFERENCES pr_cred (COLLECT_FACT)
        );