--Удаление счетчика для таблиц
DROP SEQUENCE all_id_cred_seq;
--Счетчик для таблиц
CREATE SEQUENCE all_id_cred_seq start WITH 7000000000001;

--Тригер для клиента
DROP TRIGGER client_insert_tr;

CREATE OR REPLACE TRIGGER client_insert_tr
BEFORE INSERT ON client
FOR EACH ROW
BEGIN
    IF :new.id IS NULL THEN
        SELECT all_id_cred_seq.nextval INTO :new.id FROM DUAL;
    END IF;
END;

--Тригер для кредитного портфеля
DROP TRIGGER pr_cred_insert_id_tr;
    
CREATE OR REPLACE TRIGGER pr_cred_insert_id_tr
BEFORE INSERT ON pr_cred
FOR EACH ROW
BEGIN
    IF :new.id IS NULL THEN
        SELECT all_id_cred_seq.nextval INTO :new.id FROM DUAL;
    END IF;
END;

--Добавление идентификатора для плана выплат.
DROP TRIGGER pr_cred_insert_plan_tr;

CREATE OR REPLACE TRIGGER pr_cred_insert_plan_tr
BEFORE INSERT ON pr_cred
FOR EACH ROW
BEGIN
    IF :new.id IS NULL THEN
        SELECT all_id_cred_seq.nextval INTO :new.collect_plan FROM DUAL;
    END IF;
END;

--Добавление идентификатора для фактических выплат.
DROP TRIGGER pr_cred_insert_fact_tr;
    
CREATE OR REPLACE TRIGGER pr_cred_insert_fact_tr
BEFORE INSERT ON pr_cred
FOR EACH ROW
BEGIN
    IF :new.id IS NULL THEN
        SELECT all_id_cred_seq.nextval INTO :new.collect_fact FROM DUAL;
    END IF;
END;