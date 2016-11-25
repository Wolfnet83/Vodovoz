class MissedCallsController < ApplicationController

  before_filter :authenticate_user!
  def index
    @title = "Пропущенные звонки"
    t = Time.now.strftime("%Y-%m-%d")
    h = Time.now.hour
    @date = params[:date].presence || t
    @hour = params[:hour].presence || h

    query = " select calldate,src,billsec from asteriskcdrdb.cdr where dst=111
    and hour(calldate)=#{@hour} and date(calldate)=\"#{@date}\" and
    dstchannel='' and duration > 0"
    @calls = Call.find_by_sql(query)
  end
end
