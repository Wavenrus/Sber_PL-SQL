-- Создаем процедуру заполнения плановых платежей
-------------------------------------------
drop procedure plan_operacii;

create or replace procedure plan_operacii(
    collection_id   IN plan_oper.collection_id%TYPE,
    date_begin      IN DATE,            --Дата начала договора
    interest_rate   IN NUMBER,          --Процент по кредиту
    summa_contract  IN plan_oper.p_summa%TYPE,          --Сумма договора
    credit_term     IN NUMBER           --Срок кредита-месяц
    )
IS
balance_cred    NUMBER(10,2);    --остаток долга
summ_repayment  NUMBER(10,2);    --сумма выплат по долгу
summ_proc       NUMBER(10,2);    --сумма выплат процентов
data_repayment  Date;            --дата выплаты
proc_rate       NUMBER(10,2);    --процентная ставка
count_loop number;
BEGIN
    balance_cred := summa_contract;
    summ_repayment := summa_contract / credit_term;
    data_repayment := date_begin;
    count_loop := 1;
    summ_proc := 0;
    proc_rate := interest_rate /100;
    
    INSERT INTO plan_oper VALUES (collection_id, data_repayment, summa_contract, 'Выдача кредита');
    
    WHILE count_loop <= credit_term
    LOOP
           
           data_repayment := ADD_MONTHS(date_begin, count_loop);
           
           INSERT INTO plan_oper VALUES (collection_id, data_repayment, summ_repayment, 'Погашение кредита');
           
           summ_proc := balance_cred * proc_rate / 12;
           
           INSERT INTO plan_oper VALUES (collection_id, data_repayment, summ_proc, 'Погашение процентов');
           
           balance_cred := balance_cred - summ_repayment;
           
           count_loop := count_loop + 1;
    END LOOP;
END;

-- Создаем процедуру открытия кредитного портфеля.
-------------------------------------------
drop procedure cred_portfolio;

create or replace procedure cred_portfolio(
    id_client		IN NUMBER,			--ИД клиента
	num_dog			VARCHAR2,			--Номер договора
    date_begin   	IN DATE,			--Дата начала
    interest_rate	IN NUMBER,          --Процент 
    credit_term		IN NUMBER,          --Срок кредита-месяц
	summa_contract	IN NUMBER			--Сумма кредита
    )
AS
	data_end  Date;            --дата окончания договора
	p_collection_id	NUMBER(15);		--ID плановых операций
	
BEGIN
	data_end := ADD_MONTHS(date_begin, credit_term);
	 
	INSERT INTO pr_cred VALUES(null, num_dog, summa_contract, date_begin, data_end, id_client, null, null);
	
	p_collection_id := id_plan_oper(num_dog);
	
	plan_operacii(p_collection_id, date_begin, interest_rate, summa_contract, credit_term);
END;