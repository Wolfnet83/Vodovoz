class ReportsController < ApplicationController
  def index
  end

  def incoming_calls
    t = Time.now.strftime("%Y-%m-%d")
    @date_from = params[:from] || t
    @date_to = params[:to] || t
    @call_duration = params[:duration] || 60
    group_by = params[:group_by] || "date(calldate)"
    @calls = Call.where("date(calldate)>=? AND date(calldate)<=? AND dst=111 AND billsec>?",@date_from,@date_to,@call_duration).count(:src, :group => "#{group_by}")
  end

end
