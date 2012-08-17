class CallsController < ApplicationController
  def index
    require 'open-uri'
    t = Time.now.strftime("%Y-%m-%d")
    @date_from = params[:from].presence || t
    @date_to = params[:to].presence || t
    @src = params[:src].presence 
    @dst = params[:dst].presence 
    @page = params[:page].presence || 0

    where_clause = "date(calldate) >= ? and date(calldate) <= ?"
    where_clause += " AND src=?" if params[:src].presence
    where_clause += " AND dst=?" if params[:dst].presence
    where_with_params = where_clause,@date_from,@date_to,@src,@dst
    where_with_params.compact!

    #Realising pagination
    count=CDR::Call.where(where_with_params).count
    @page = @page.to_i
    @pages = count/50.round
    if @page>=3 then @page_from=@page-3 
    else
      @page_from=0
    end
    if @page<=@pages-3 then @page_to=@page+3
    else
      @page_to=@pages
    end


    @calls=CDR::Call.where(where_with_params).limit(50).offset(@page*50)

    date = @date_to.to_s[0..-4].delete"-"
    
    @monitor_files=Array.new
    open("http://10.0.0.203/monitor_files"+date+".txt") {|f| @monitor_files = f.to_a }

    @calls.each do |call|
      if call.disposition == "ANSWERED" then call.disposition ="Отвечен";end
      filename = @monitor_files.select{|f| f.include?call.uniqueid}.compact
      if !filename.empty? then 
        call.link = "http://10.0.0.203/maint/cache/monitor/"+filename.to_s[2..-5] 
        call.linkname = "Запись разговора"
      else
        call.link = "No record"
        call.linkname = "Нет записи"
      end
    end
  end

end
