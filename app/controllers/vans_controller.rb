class VansController < ApplicationController

  before_action :van_find, only: [:show]
  skip_before_action :authenticate_user!, only: [ :index, :show ]

  def orders
    @van = Van.find(params[:van_id])
    @orders = @van.orders
  end

  def new
    @van = Van.new
  end

  def create
    @van = current_user.build_van(van_params) # Allows each user to have only one van
    if @van.save
      flash[:notice] = "You are now a van driver!"
      redirect_to @van
    else
      render :new
    end
  end

  def index
    @location = params[:query]
    @vans = Van.all
    @markers = @vans.geocoded.map do |van|
      {
        lat: van.latitude,
        lng: van.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: {van: van}),
        marker_html: render_to_string(partial: "marker", locals: {van: van}),
        marker_html: render_to_string(partial: "marker", locals: {location: location})
      }
    end
  end

  def show
    @user = @van.user
    @products = @van.products
    @inventories = @van.inventories.includes(:product)
    # @product = @inventories.find_by(product_id: params[:id])
  end

  private

  def van_find
    @van = Van.find(params[:id])
  end

  def van_params
    params.require(:van).permit(:name, :location)
  end
end
