class WinesController < ApplicationController
  require 'rest-client'

  def index
    @wines = Wine.all
  end

  def show
    @wine = Wine.find(params[:id])
  end
end
