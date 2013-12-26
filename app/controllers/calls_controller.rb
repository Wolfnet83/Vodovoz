﻿class CallsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @title = "Таблица звонков"
    t = Date.today.to_formatted_s(:db)
    @date_from = params[:call_from].presence || t
    @date_to = params[:call_to].presence || t
    @src = params[:src].presence 
    @dst = params[:dst].presence 

    #where_clause = "date(calldate) >= ? and date(calldate) <= ? AND (billsec>0 or src between 300 and 399) and (dst<>111 or dstchannel='')"
    #where_clause += " AND src=?" if params[:src].presence
    #where_clause += " AND dst=?" if params[:dst].presence
    #where_with_params = where_clause,@date_from,@date_to,@dst
    #where_with_params.compact!

    @calls=Call.main(@date_from, @date_to).source(@src).dest(@dst).page params[:page]
    #@calls=CDR::Call.where(where_with_params).to_a.page(1)
    #@calls=Call.page(1).per(1)
    
    logger.info "*"*80
    logger.info @calls.inspect
    logger.info "*"*80

    begin
      @monitor_date = @date_to.to_s[0..-4].delete"-"
      @monitor_files=Array.new
      datename="http://10.0.0.203/monitor_files"+@monitor_date+".txt"
        open(datename) {|f| @monitor_files = f.to_a }
      rescue
    end

    
    @calls.each do |call|
      filename = @monitor_files.select{|f| f.include?call.uniqueid}.compact
      if !filename.empty? then 
        call.link = "http://10.0.0.203/maint/cache/monitor/"+filename.to_s[2..-5] 
        call.linkname = "Запись разговора"
      elsif call.disposition == "ANSWERED" and !call.userfield.empty? then
          call.link = "http://10.0.0.203/maint/cache/monitor/"+call.userfield
          call.linkname = "Прослушать"
        else
          call.link = "No record"
          call.linkname = "Нет записи"
      end
    end
  end

end
