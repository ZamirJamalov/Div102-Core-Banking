create table cb_currencies 
(id number generated always as identity primary key,
 name varchar2(30),
 code varchar2(30));
 
 create or replace procedure cb_currencies_insert
 (p_name varchar2,p_code varchar2) is
 begin
    insert into cb_currencies(name,code) values(p_name,p_code);
    commit;
 end;
 
 create or replace procedure cb_currencies_update
 (p_id number, p_name varchar2 default null, p_code varchar2 default null) is
 begin
   update cb_currencies  set  name=nvl(p_name,name), code=nvl(p_code,code)
     where id=p_id;
    commit;
 end;
 