class WinesController < ApplicationController
  def index
    @wine = Wine.all
  end

  def show
    @wine = Wine.find(params[:id])
  end
end
