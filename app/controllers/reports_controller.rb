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
    @calls = Call.where("(calldate >= ? AND calldate <= ? + INTERVAL 1 DAY) AND dst=111 AND billsec>?",@date_from,@date_to,@call_duration).group(group_by).count(:src)
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
      where (A.calldate BETWEEN DATE(\'#{@date}\') AND DATE(\'#{@date}\')+ INTERVAL 1 DAY)
      AND hour(A.calldate) BETWEEN '8' AND '17'
      and (duration>10 or dstchannel<>'')
      and dst =111
     union all
      select hour(calldate) as h,0 as c1,1 as c2,0 as c3
      from `asteriskcdrdb`.`cdr`
      where (calldate BETWEEN DATE(\'#{@date}\') AND DATE(\'#{@date}\')+ INTERVAL 1 DAY)
      AND hour(calldate) BETWEEN '8' AND '17'
      and src between 300 and 399
      and (dcontext = 'vodovoz-department' or dcontext = 'from-internal')
     union all
      select hour(B.calldate) as h,0 as c1,0 as c2,1 as c3
      from `asteriskcdrdb`.`cdr` as B
      where (B.calldate BETWEEN DATE(\'#{@date}\') AND DATE(\'#{@date}\')+ INTERVAL 1 DAY)
      AND hour(B.calldate) BETWEEN '8' AND '17'
      and (dst = 111 and dstchannel<>'')
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
      and (dst = 111 and dstchannel<>'')
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
      and (dst = 111 and dstchannel<>'')
      and disposition = 'ANSWERED') as Q
     group by h;";
    end
     @calls = Call.find_by_sql(query)
  end

  def operator
    @title = 'Отчет по звонкам по оператору'
    t = Time.now.strftime("%Y-%m-%d")
    @date_from = params[:date_from].presence || t
    @date_to = params[:date_to].presence || t
    date_to = (@date_to.to_date + 1.day).to_s
    if params[:op_number].presence
      @calls_in = Call.where(calldate: @date_from..date_to, dst: params[:op_number], disposition: "ANSWERED").count
      @calls_out = Call.where(calldate: @date_from..date_to, src: params[:op_number]).count
      @calls_out_res = Call.where(calldate: @date_from..date_to, src: params[:op_number], disposition: "ANSWERED").count
    end
  end

  def unanswered_calls
    missed_calls = Call.where("calldate BETWEEN DATE(?) AND DATE(?) + INTERVAL 1 DAY
                                AND dst='111' and dstchannel=''", params[:date], params[:date])
    @unrepeated_calls = []
    missed_calls.each do |call|
      repeated_call = Call.where("calldate > ?
                                AND calldate < DATE(? + INTERVAL 1 DAY)
                                AND (src=? or dst=9#{call.src})", call.calldate, call.calldate, call.src)
      @unrepeated_calls << call unless repeated_call.presence
    end
  end
end
