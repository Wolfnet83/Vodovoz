class CallsController < ApplicationController
  def index
    require 'open-uri'
    t = Time.now.strftime("%Y-%m-%d")
    @date_from = params[:from].presence || t
    @date_to = params[:to].presence || t
    @page = params[:page].presence || 0
    @page= @page.to_i
    @page_from=@page-3
    @page_to=@page+3
    count=CDR::Call.where(:calldate =>(@date_from..@date_to)).count
    @pages = count/50.round
    @calls=CDR::Call.where(:calldate =>(@date_from..@date_to)).limit(50).offset(@page*50)
#    monitor_files = open('http://10.0.0.203/monitor_files.txt').read
    #@calls.each do |call|
    #  if call.disposition == "ANSWERED" then call.disposition ="Отвечен";end
    #end
  end

end
