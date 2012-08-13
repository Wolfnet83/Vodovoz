class MissedCallsController < ApplicationController
  def index
    t = Time.now.strftime("%Y-%m-%d")
    h = Time.now.hour
    @date = params[:date].presence || t
    @hour = params[:hour].presence || h
    query = " select src,count(src),A.disP from  asteriskcdrdb.cdr C
      LEFT OUTER JOIN (SELECT SRC S,COUNT(SRC) CS,DISPOSITION DISP from  asteriskcdrdb.cdr where  dst<>111 and hour(calldate)='$work_hour' and date(calldate)='$work_date' AND DISPOSITION='ANSWERED' and billsec>5 GROUP BY SRC ) A ON A.S=C.SRC where  dst=111 and hour(calldate)='$work_hour' and date(calldate)='$work_date' 
    group by src
    HAVING COUNT(A.S)=0;"
    @calls = CDR::Call.find_by_sql(query)
    logger.info "*"*80
    logger.info @calls.inspect
    logger.info "*"*80
  end
end
