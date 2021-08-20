*************************************
--Отчет состояние кредитных портфелей на заданную дату.
*************************************
--Создаём тип возвращаемых данных

create or replace type t_pr_cred_report as object
(
  num_dog    VARCHAR2(10),
  cl_name    VARCHAR2(200),
  summa_dog  NUMBER,
  date_begin    DATE,
  date_end      DATE,
  ostatok_to_date  NUMBER,
  ost_perc_to_date  NUMBER,
  report_dt     DATE
);

create or replace type t_pr_cred_report_table as table of t_pr_cred_report;

--Создаем функцию
create or replace function func_pr_cred_report(in_to_dt date)
  return t_pr_cred_report_table
  pipelined as
begin
  for rec in 
    (
        select pc.num_dog                                                               num_dog     
                ,cl.cl_name                                                             cl_name
                ,pc.summa_dog                                                           summa_dog
                ,pc.date_begin                                                          date_begin  
                ,pc.date_end                                                            date_end
                ,NVL(ostatok_to_date(in_to_dt, pc.collect_fact), 0)                     ostatok_to_date
                ,NVL(ost_perc_to_date(in_to_dt, pc.collect_plan, pc.collect_fact), 0)   ost_perc_to_date
                ,in_to_dt                                                               report_dt
        from pr_cred pc, CLIENT cl
        where pc.id_client = cl.id
			and pc.date_begin <= in_to_dt)
    loop
        pipe row(t_pr_cred_report(rec.num_dog,
                                rec.cl_name,
                                rec.summa_dog,
                                rec.date_begin,
                                rec.date_end,
                                rec.ostatok_to_date,
                                rec.ost_perc_to_date,
                                rec.report_dt)
                );
     end loop;
end;

-- Отчет по кредитным портфелям на заданную дату
  
select   num_dog as "№ Договора"
        ,cl_name as "ФИО Клиента"
        ,summa_dog as "Сумма договора"
        ,date_begin as "Дата начала договора"
        ,date_end as "Дата окончания договора"
        ,ostatok_to_date as "Остаток долга"
        ,ost_perc_to_date as "Сумма % к погашению"
        ,report_dt as "Отчет на дату"
  from table(func_pr_cred_report(to_date('01.01.22', 'dd.mm.yy')));
  
*************************************************************************