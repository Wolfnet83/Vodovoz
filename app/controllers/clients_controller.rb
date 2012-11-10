class ClientsController < ApplicationController
  before_filter :authenticate_user!
  def index
    by_field = params[:sort_by] || "id"
    @clients = Client.order("#{by_field} #{params[:dir]}" )
   # @clients = Client.all
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(params[:client])
    if @client.save
      redirect_to @client, notice: "Клиент создан"
    else
      render "new"
    end
  end

  def destroy
    @client = Client.find(params[:id])
    @client.destroy
    redirect_to clients_path
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])
    @client.update_attributes(params[:client])
    redirect_to @client, notice: 'Данные клиента обновлены'
  end

  def show
    @client = Client.find(params[:id])
  end

end
