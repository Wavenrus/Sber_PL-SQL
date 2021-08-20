-- Внешние таблицы
create directory lang_external as 'H:\Oracle';

drop table ImpCLIENT;
--Загружаем данные в таблицу клиенты

 CREATE TABLE ImpCLIENT
    (
    ID            NUMBER(15)
    , CL_NAME       VARCHAR2(200)
    , DATE_BIRTH    DATE
    )
ORGANIZATION EXTERNAL(
    TYPE oracle_loader
    DEFAULT DIRECTORY lang_external
    ACCESS PARAMETERS 
    (
    RECORDS DELIMITED BY NEWLINE
    SKIP 1
    FIELDS TERMINATED BY ';'
    ALL FIELDS OVERRIDE
    REJECT ROWS WITH ALL NULL FIELDS
        (
        DATE_BIRTH CHAR(10) DATE_FORMAT DATE MASK "DD/MM/YYYY"
        )
    )
    LOCATION ('client.csv')
);

INSERT INTO CLIENT
    SELECT * FROM ImpCLIENT;
	
------------------------------------
drop table ImpPr_cred;

--Загружаем данные в таблицу кредитный портфель

 CREATE TABLE ImpPr_cred
    (
    ID            NUMBER(15)
    , NUM_DOG       VARCHAR2(10)
    , SUMMA_DOG     VARCHAR2(20)
    , DATE_BEGIN    DATE
    , DATE_END      DATE
    , ID_CLIENT     NUMBER(15)
    , COLLECT_PLAN  NUMBER(15)
    , COLLECT_FACT  NUMBER(15)
    )
ORGANIZATION EXTERNAL(
    TYPE oracle_loader
    DEFAULT DIRECTORY lang_external
    ACCESS PARAMETERS 
    (
    RECORDS DELIMITED BY NEWLINE
    SKIP 1
    FIELDS TERMINATED BY ';'
    ALL FIELDS OVERRIDE
    REJECT ROWS WITH ALL NULL FIELDS
    DATE_FORMAT DATE MASK "DD.MM.YYYY"
        (     ID
            , NUM_DOG
            , SUMMA_DOG
            , DATE_BEGIN CHAR(10)
            , DATE_END CHAR(10)
            , ID_CLIENT
            , COLLECT_PLAN
            , COLLECT_FACT
        )
    )
    LOCATION ('pr_cred.csv')
);
--REJECT LIMIT 20;

INSERT INTO pr_cred
    SELECT   ID
            , NUM_DOG
            , TO_NUMBER(SUMMA_DOG)
            , DATE_BEGIN
            , DATE_END
            , ID_CLIENT
            , COLLECT_PLAN
            , COLLECT_FACT
    FROM ImpPr_cred;
------------------------------------
drop table ImpFACT_OPER;

--Загружаем данные в таблицу фактические операции

 CREATE TABLE ImpFACT_OPER(
    COLLECTION_ID NUMBER(15)
    , F_DATE    DATE
    , F_SUMMA     VARCHAR2(20)
    , TYPE_OPER     VARCHAR2(200)
)
ORGANIZATION EXTERNAL(
    TYPE oracle_loader
    DEFAULT DIRECTORY lang_external
    ACCESS PARAMETERS 
    (
    RECORDS DELIMITED BY NEWLINE
    SKIP 1
    FIELDS TERMINATED BY ';'
    ALL FIELDS OVERRIDE
    REJECT ROWS WITH ALL NULL FIELDS
        (
        F_DATE CHAR(10) DATE_FORMAT DATE MASK "DD.MM.YYYY"
        )
    )
    LOCATION ('FACT_OPER.csv')
)
--REJECT LIMIT 20;

INSERT INTO FACT_OPER
    SELECT COLLECTION_ID
            , F_DATE
            , TO_NUMBER(F_SUMMA)
            , TYPE_OPER
    FROM ImpFACT_OPER;
	
------------------------------------
drop table ImpPLAN_OPER;

--Загружаем данные в таблицу плановые операции

 CREATE TABLE ImpPLAN_OPER(
    COLLECTION_ID NUMBER(15)
    , P_DATE    DATE
    , P_SUMMA     VARCHAR2(20)
    , TYPE_OPER     VARCHAR2(200)
)
ORGANIZATION EXTERNAL(
    TYPE oracle_loader
    DEFAULT DIRECTORY lang_external
    ACCESS PARAMETERS 
    (
    RECORDS DELIMITED BY NEWLINE
    SKIP 1
    FIELDS TERMINATED BY ';'
    ALL FIELDS OVERRIDE
    REJECT ROWS WITH ALL NULL FIELDS
        (
        P_DATE CHAR(10) DATE_FORMAT DATE MASK "DD.MM.YYYY"
        )
    )
    LOCATION ('PLAN_OPER.csv')
)
--REJECT LIMIT 20;

INSERT INTO PLAN_OPER
    SELECT COLLECTION_ID
            , P_DATE
            , TO_NUMBER(P_SUMMA)
            , TYPE_OPER
    FROM ImpPLAN_OPER;
	
-----------------------------------