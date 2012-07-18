class ClientsController < ApplicationController
  def list
    @clients = Client.all
  #  if sort_by @clients = Client.order("company")
  end

  def create
  end

  def delete
  end

  def update
  end

end
