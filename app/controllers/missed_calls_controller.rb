class MissedCallsController < ApplicationController
  def index
    t = Time.now.strftime("%Y-%m-%d")
    h = Time.now.hour
    @date = params[:date].presence || t
    @hour = params[:hour].presence || h
    query = " select src,count(src),A.disP from  asteriskcdrdb.cdr C
      LEFT OUTER JOIN (SELECT SRC S,COUNT(SRC) CS,DISPOSITION DISP 
      from  asteriskcdrdb.cdr where  dst<>111 and hour(calldate)=#{@hour} 
      and date(calldate)=\"#{@date}\" AND DISPOSITION='ANSWERED' and billsec>5 GROUP BY SRC ) A ON A.S=C.SRC 
      where  dst=111 and hour(calldate)=#{@hour} and date(calldate)=\"#{@date}\" 
      group by src
      HAVING COUNT(A.S)=0;"
    missed_calls = CDR::Call.find_by_sql(query)
    arr = Array.new
    missed_calls.each do |missed_call|
      arr << missed_call.src
    end
    arr=arr.to_s[1..-2]
    query = " select time(calldate) as my_time,src,billsec from asteriskcdrdb.cdr where dst=111 
    and hour(calldate)=#{@hour} and date(calldate)=\"#{@date}\"";# and src in (#{arr})";
    @calls = CDR::Call.find_by_sql(query)
    logger.info "*"*80
    logger.info @calls.inspect
    logger.info "*"*80
  end
end
