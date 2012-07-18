class ClientsController < ApplicationController
  def index
    by_field = params[:sort_by] || "id"
    @clients = Client.order("#{by_field} DESC" )
   # @clients = Client.all
  end

  def create
  end

  def delete
  end

  def edit
    @client = Client.find(params[:id])
  end

end
