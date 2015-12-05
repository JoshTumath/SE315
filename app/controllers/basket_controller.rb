class BasketController < ApplicationController
  def index
    @basket = session[:basket]
  end

  def create
    add params[:basket]

    redirect_to basket_index_path
  end

  def update
    # TODO
    #Basket.add params[:basket]
    redirect_to basket_index_path
  end

  def destroy
    if params[:wine]
      #Basket.delete params[:wine]
    else
      #Basket.clear
    end

    redirect_to basket_index_path
  end

  private
  def create_if_not_existing
    if !session.has_key? :basket
      session[:basket] = {}
    end
  end

  def add(order)
    create_if_not_existing

    order.symbolize_keys
    session[:basket][order[:wine]] = order[:quantity].to_i
  end
end
