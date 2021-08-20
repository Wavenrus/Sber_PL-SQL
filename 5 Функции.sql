-- Создаем функцию для получения статка ссудной задолженности на дату
-------------------------------------------
create or replace function ostatok_to_date (
  in_date IN DATE,
  COLLECT_FACT IN NUMBER) RETURN NUMBER
IS
  ost_sum NUMBER(8,2);
BEGIN
    select   issuance_sum - repay_sum as ost_sum
    INTO ost_sum
    from
        (select fc.collection_id, sum(fc.f_summa) as repay_sum
            from FACT_OPER fc
            where  fc.type_oper = 'Погашение кредита'
                 and fc.f_date <= in_date
                 and fc.collection_id = COLLECT_FACT
            group by fc.collection_id) rep_sum,
        (select fc.collection_id, sum(fc.f_summa) as issuance_sum
            from FACT_OPER fc
            where  fc.type_oper = 'Выдача кредита'
                and fc.f_date <= in_date
                and fc.collection_id = COLLECT_FACT
            group by fc.collection_id) issuance_sum
    where rep_sum.collection_id = issuance_sum.collection_id
        and ROWNUM = 1;

   RETURN ost_sum;
END ostatok_to_date;
---------------------------------------------------------------------
-- Создаем функцию для получения суммы предстоящих процентов к погашению
-------------------------------------------
create or replace function ost_perc_to_date (
  in_date IN DATE,
  COLLECT_PLAN IN NUMBER,
  COLLECT_FACT IN NUMBER) RETURN NUMBER
IS
  ost_sum_perc NUMBER(8,2);
BEGIN
    select   p_perc_sum - f_perc_sum as ost_sum_perc
    INTO ost_sum_perc
    from
        (select fc.collection_id, sum(fc.f_summa) as f_perc_sum
            from FACT_OPER fc
            where  fc.type_oper = 'Погашение процентов'
                 and fc.f_date <= in_date
                 and fc.collection_id = COLLECT_FACT
            group by fc.collection_id) sum_f_perc,
        (select pc.collection_id, sum(pc.p_summa) as p_perc_sum
            from PLAN_OPER pc
            where  pc.type_oper = 'Погашение процентов'
                and pc.p_date <= in_date
                and pc.collection_id = COLLECT_PLAN
            group by pc.collection_id) sum_p_perc
    where ROWNUM = 1;

   RETURN ost_sum_perc;
END ost_perc_to_date;