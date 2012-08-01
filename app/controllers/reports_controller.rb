﻿class ReportsController < ApplicationController
  def index
  end

  def incoming_calls
    t = Time.now.strftime("%Y-%m-%d")
    @date_from = params[:from].presence || t
    #logger.info "*" * 80
    #logger.info @date_from.inspect
    #logger.info "*" * 80
    @date_to = params[:to].presence || t
    @call_duration = params[:duration].presence || 60
    group_by = params[:group_by] || "date(calldate)"
    @calls = CDR::Call.where("date(calldate)>=? AND date(calldate)<=? AND dst=111 AND billsec>?",@date_from,@date_to,@call_duration).count(:src, :group => "#{group_by}")
  end

  def main_report
    t = Time.now.strftime("%Y-%m-%d")
    @date = params[:date].presence || t
    group_by = params[:group_by] || "day"
    if group_by == "day"  
      @date_column = "Час"
    query ="select h as 'time',sum(c1)+sum(c2) as 'quantity_all', sum(c1) as quantity_in,sum(c2) as quantity_out, sum(c3) as received, sum(c1)-sum(c3) as missed
    from(
      select hour(A.calldate) as h,1 as c1, 0 as c2,0 as c3
      from `asteriskcdrdb`.`cdr` as A
      where date(A.calldate)=\'#{@date}\'
      and dst =111
      and billsec > 5 
     union all
      select hour(calldate) as h,0 as c1,1 as c2,0 as c3
      from `asteriskcdrdb`.`cdr`
      where date(calldate)=\'#{@date}' 
      and src in (select sipname from asterisk.users where sipname<>'')
      and billsec > 5 
     union all
      select hour(B.calldate) as h,0 as c1,0 as c2,1 as c3
      from `asteriskcdrdb`.`cdr` as B
      where date(B.calldate)=\'#{@date}\'
      and dst in (select sipname from asterisk.users where sipname<>'')
      and billsec > 5
      and dcontext = 'from-internal') as Q
     group by h"
    elsif group_by == "week"
      @date_column = "День недели"
    query ="
    select h as 'time',sum(c1)+sum(c2) as 'quantity_all', sum(c1) as quantity_in,sum(c2) as quantity_out, sum(c3) as received, sum(c1)-sum(c3) as missed
    from(
     select day(A.calldate) as h,1 as c1, 0 as c2,0 as c3
      from `asteriskcdrdb`.`cdr` as A
      where week(A.calldate,1)=week(\'#{@date}\',1)
      and year(A.calldate)=year(\'#{@date}\')
      and dst =111
      and billsec > 5 
     union all
      select day(C.calldate) as h,0 as c1,1 as c2,0 as c3
      from `asteriskcdrdb`.`cdr` as C
      where week(C.calldate,1)=week(\'#{@date}\',1)
      and year(C.calldate)=year(\'#{@date}\')
      and src in (select sipname from asterisk.users where sipname<>'')
      and billsec > 5 
     union all
      select day(B.calldate) as h,0 as c1,0 as c2,1 as c3
      from `asteriskcdrdb`.`cdr` as B
      where week(B.calldate,1)=week(\'#{@date}\',1)
      and year(B.calldate)=year(\'#{@date}\')
      and dst in (select sipname from asterisk.users where sipname<>'')
      and billsec > 5
      and dcontext = 'from-internal') as Q
     group by h;"
    else 
      @date_column = "Месяц"
    query ="
    select h as 'time',sum(c1)+sum(c2) as 'quantity_all', sum(c1) as quantity_in,sum(c2) as quantity_out, sum(c3) as received, sum(c1)-sum(c3) as missed
    from(
      select month(A.calldate) as h,1 as c1, 0 as c2,0 as c3
      from `asteriskcdrdb`.`cdr` as A
      where year(A.calldate)=year(\'#{@date}\')
      and dst =111
      and billsec > 5 
     union all
      select month(C.calldate) as h,0 as c1,1 as c2,0 as c3
      from `asteriskcdrdb`.`cdr` as C
      where year(C.calldate)=year(\'#{@date}\')
      and src in (select sipname from asterisk.users where sipname<>'')
      and billsec > 5 
     union all
      select month(B.calldate) as h,0 as c1,0 as c2,1 as c3
      from `asteriskcdrdb`.`cdr` as B
      where year(B.calldate)=year(\'#{@date}\')
      and dst in (select sipname from asterisk.users where sipname<>'')
      and billsec > 5
      and dcontext = 'from-internal') as Q
     group by h;";
    end
     @calls = CDR::Call.find_by_sql(query)
  end
end
