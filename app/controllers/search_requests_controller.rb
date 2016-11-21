class SearchRequestsController < ApplicationController
  before_action :authenticate_user!, :except => [:create]

  def index
    @date_from = (Date.today - 1.months).to_formatted_s(:db)
    @date_to = Date.today.to_formatted_s(:db)
    @search_requests = SearchRequest.order(id: :desc)
  end

  def create
    @search_request = SearchRequest.new(permitted_params)
    if @search_request.valid?
      @search_request.save
      head :ok
    end
  end

  def destroy
    @search_request = SearchRequest.find_by_id(params[:id])
    @search_request.destroy
    redirect_to search_requests_path
  end

  private
  def permitted_params
    params[:search_request].permit(:username, :user_phone, :client_name, :client_phone)
  end
end
