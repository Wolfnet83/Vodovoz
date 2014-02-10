class ReportsController < ApplicationController
  before_filter :authenticate_user!
  def index
  end

  def incoming_calls
    t = Time.now.strftime("%Y-%m-%d")
    @date_from = params[:from].presence || t
    @date_to = params[:to].presence || t
    @call_duration = params[:duration].presence || 60
    group_by = params[:group_by] || "date(calldate)"
    @calls = Call.where("date(calldate)>=? AND date(calldate)<=? AND dst=111 AND billsec>?",@date_from,@date_to,@call_duration).count(:src, :group => "#{group_by}")
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
      where date(A.calldate)=\'#{@date}\' AND hour(A.calldate) BETWEEN '8' AND '17'
      and (duration>10 or dstchannel<>'')
      and dst =111
     union all
      select hour(calldate) as h,0 as c1,1 as c2,0 as c3
      from `asteriskcdrdb`.`cdr`
      where date(calldate)=\'#{@date}' AND hour(calldate) BETWEEN '8' AND '17'
      and src between 300 and 399
      and (dcontext = 'vodovoz-department' or dcontext = 'from-internal')
     union all
      select hour(B.calldate) as h,0 as c1,0 as c2,1 as c3
      from `asteriskcdrdb`.`cdr` as B
      where date(B.calldate)=\'#{@date}\' AND hour(B.calldate) BETWEEN '8' AND '17'
      and dst between 300 and 399
      and src not between 300 and 399
      and disposition = 'ANSWERED') as Q
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
      AND hour(A.calldate) BETWEEN '8' AND '17'
      and (duration>10 or dstchannel<>'')
      and dst =111
     union all
      select day(C.calldate) as h,0 as c1,1 as c2,0 as c3
      from `asteriskcdrdb`.`cdr` as C
      where week(C.calldate,1)=week(\'#{@date}\',1)
      and year(C.calldate)=year(\'#{@date}\')
      AND hour(C.calldate) BETWEEN '8' AND '17'
      and src between 300 and 399
      and (dcontext = 'vodovoz-department' or dcontext='from-internal')
     union all
      select day(B.calldate) as h,0 as c1,0 as c2,1 as c3
      from `asteriskcdrdb`.`cdr` as B
      where week(B.calldate,1)=week(\'#{@date}\',1)
      and year(B.calldate)=year(\'#{@date}\')
      AND hour(B.calldate) BETWEEN '8' AND '17'
      and dst between 300 and 399
      and src not between 300 and 399
      and disposition = 'ANSWERED') as Q
     group by h;"
    else 
      @date_column = "Месяц"
    query ="
    select h as 'time',sum(c1)+sum(c2) as 'quantity_all', sum(c1) as quantity_in,sum(c2) as quantity_out, sum(c3) as received, sum(c1)-sum(c3) as missed
    from(
      select month(A.calldate) as h,1 as c1, 0 as c2,0 as c3
      from `asteriskcdrdb`.`cdr` as A
      where year(A.calldate)=year(\'#{@date}\')
      AND hour(A.calldate) BETWEEN '8' AND '17'
      AND dayofweek(A.calldate) <> '1'
      and (duration>10 or dstchannel<>'')
      and dst =111
     union all
      select month(C.calldate) as h,0 as c1,1 as c2,0 as c3
      from `asteriskcdrdb`.`cdr` as C
      where year(C.calldate)=year(\'#{@date}\')
      AND hour(C.calldate) BETWEEN '8' AND '17'
      AND dayofweek(C.calldate) <> '1'
      and src between 300 and 399
      and (dcontext = 'vodovoz-department' or dcontext='from-internal')
     union all
      select month(B.calldate) as h,0 as c1,0 as c2,1 as c3
      from `asteriskcdrdb`.`cdr` as B
      where year(B.calldate)=year(\'#{@date}\')
      AND hour(B.calldate) BETWEEN '8' AND '17'
      AND dayofweek(B.calldate) <> '1'
      and dst between 300 and 399
      and src not between 300 and 399
      and disposition = 'ANSWERED') as Q
     group by h;";
    end
     @calls = Call.find_by_sql(query)
  end

  def operator
    @calls_in = Call.where("date(calldate)>=? AND date(calldate)<=? AND dst=? and disposition = 'ANSWERED'", params[:date_from], params[:date_to], params[:op_number]).count
    @calls_out = Call.where("date(calldate)>=? AND date(calldate)<=? AND src=?", params[:date_from], params[:date_to], params[:op_number]).count
  end
end
