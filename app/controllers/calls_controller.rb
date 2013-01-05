class CallsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @title = "Таблица звонков"
    require 'open-uri'
    t = Time.now.strftime("%Y-%m-%d")
    @date_from = params[:call_from].presence || t
    @date_to = params[:call_to].presence || t
    @src = params[:src].presence 
    @dst = params[:dst].presence 

    where_clause = "date(calldate) >= ? and date(calldate) <= ? AND dst NOT BETWEEN 300 AND 399"
    where_clause += " AND src=?" if params[:src].presence
    where_clause += " AND dst=?" if params[:dst].presence
    where_with_params = where_clause,@date_from,@date_to,@src,@dst
    where_with_params.compact!

    @calls=CDR::Call.where(where_with_params).page params[:page]

    @monitor_date = @date_to.to_s[0..-4].delete"-"
#    @monitor_files=Array.new
#    open("http://10.0.0.203/monitor_files"+@monitor_date+".txt") {|f| @monitor_files = f.to_a }

    @calls.each do |call|
      if call.disposition == "ANSWERED" then call.disposition ="Отвечен";end
#      filename = @monitor_files.select{|f| f.include?call.uniqueid}.compact
#      filename = monitorfiles2mysql.where("filenames like %?%", call.uniqueid) 
      filename = Filename.where("filenames like \"%#{call.uniqueid}%\"")

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
