class ReportsController < ApplicationController
  before_action :authenticate_user!
  def index
    @title = "Отчеты"
  end

  def incoming_calls
    @title = "Отчет по входящим звонкам"
    t = Time.now.strftime("%Y-%m-%d")
    @date_from = params[:from].presence || t
    @date_to = params[:to].presence || t
    @call_duration = params[:duration].presence || 60
    group_by = params[:group_by] || "date(calldate)"
    @calls = Call.where("(calldate >= ? AND calldate <= ? + INTERVAL 1 DAY) AND dst=111 AND billsec>?",@date_from,@date_to,@call_duration).group(group_by).count(:src)
  end

  def main_report
    @title = "Основной отчет"
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
      and (duration>25 or dstchannel<>'')
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
     @calls = Call.find_by_sql(query)
    elsif group_by == "week"
      @date_column = "День недели"
      date_begin = @date.to_date.beginning_of_week
      date_end = @date.to_date.end_of_week
      @calls = AggregatedCall.where(calldate: date_begin..date_end)
    else
      @date_column = "Месяц"
      date_begin = @date.to_date.beginning_of_year
      date_end = @date.to_date.end_of_year
      aggregated_calls = AggregatedCall.where(calldate: date_begin..date_end)
      @calls = []

      (1..12).each do |month| 
        month_calls = aggregated_calls.where("MONTH(calldate) = ?", month)
        ac_month = AggregatedCall.new(calldate: month,
                                    quantity_all: month_calls.sum(:quantity_all),
                                    quantity_in: month_calls.sum(:quantity_in),
                                    quantity_out: month_calls.sum(:quantity_in),
                                    received: month_calls.sum(:quantity_in),
                                    missed: month_calls.sum(:quantity_in))
        @calls << ac_month
      end
    end
  end

  def operator
    @title = 'Отчет по звонкам по оператору'
    t = Time.now.strftime("%Y-%m-%d")
    @date_from = params[:date_from].presence || t
    @date_to = params[:date_to].presence || t
    date_to = (@date_to.to_date + 1.day).to_s
    if params[:op_number].presence
      @calls_in = Call.where(calldate: @date_from..date_to, dst: params[:op_number], disposition: "ANSWERED").count
      @calls_out = Call.where(calldate: @date_from..date_to, src: params[:op_number])
                       .where("dst <> \'*78\' AND dst <> \'*79\'")
                       .count
      @calls_out_res = Call.where(calldate: @date_from..date_to, src: params[:op_number], disposition: "ANSWERED")
                           .where("dst <> \'*78\' AND dst <> \'*79\'")
                           .count
    end
  end

  def missed_calls
    @title = "Пропущенные звонки"
    t = Time.now.strftime("%Y-%m-%d")
    h = Time.now.hour
    @date = params[:date].presence || t
    @hour = params[:hour].presence || h
    time = @date.to_date + @hour.to_i.hours

    @calls = Call.select(:calldate, :src, :billsec)
                 .where(dst: '111', dstchannel: '' )
                 .where("calldate >= ? and calldate <= ?", time.to_s, time.end_of_hour.to_s)
                 .where('duration > 0')

  end

  def unanswered_calls
    @title = "Пропущенные звонки без ответа"
    t = Time.now.strftime("%Y-%m-%d")
    @date = params[:date].presence || t
    query = "SELECT * FROM asteriskcdrdb.cdr AS a WHERE
            calldate BETWEEN DATE(\'#{@date}\') AND DATE(\'#{@date}\') + INTERVAL 1 DAY
            AND (dst='111' AND dstchannel='')
              AND src NOT IN (
              SELECT src FROM asteriskcdrdb.cdr WHERE
              (calldate BETWEEN a.calldate AND a.calldate + INTERVAL 1 DAY)
              AND (dst <> '111' and disposition='ANSWERED')
              )
              AND CONCAT(9,src) NOT IN (
              SELECT dst FROM asteriskcdrdb.cdr WHERE
              (calldate > a.calldate AND calldate < a.calldate + INTERVAL 1 DAY)
              AND (dst <> '111' AND disposition='ANSWERED')
              AND (dst NOT BETWEEN 300 AND 399)
              ) "

    @unrepeated_calls = Call.find_by_sql(query)
  end
end
