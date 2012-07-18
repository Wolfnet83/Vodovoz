class ClientsController < ApplicationController
  def index
    by_field = params[:sort_by] || "id"
    @clients = Client.order("#{by_field}")
   # @clients = Client.all
  end

  def create
  end

  def delete
  end

  def update
  end

end
