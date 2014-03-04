class CallsController < ApplicationController
  before_filter :authenticate_user!

  def index

    @title = "Таблица звонков"
    t = Date.today.to_formatted_s(:db)
    @date_from = params[:call_from].presence || t
    @date_to = params[:call_to].presence || t
    @src = params[:src].presence 
    @dst = params[:dst].presence 

    @calls=Call.main(@date_from, @date_to).source(@src).dest(@dst).page params[:page]
    
    @calls.each do |call|
      if call.disposition == "ANSWERED" and !call.userfield.empty? then
          call.link = "http://10.0.0.203/maint/cache/monitor/"+call.userfield
          call.linkname = "Прослушать"
        else
          call.link = "No record"
          call.linkname = "Нет записи"
      end
    end
  end

end
