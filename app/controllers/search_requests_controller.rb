class SearchRequestsController < ApplicationController
  def index
    @date_from = (Date.today - 6.months).to_formatted_s(:db)
    @date_to = Date.today.to_formatted_s(:db)
    @search_requests = SearchRequest.order(id: :desc)
  end
end
