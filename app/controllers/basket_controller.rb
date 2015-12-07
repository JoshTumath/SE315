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
      session[:basket].delete params[:wine]
    else
      session[:basket].clear
    end

    redirect_to basket_index_path
  end

  private
  ##
  # If the basket does not exist in the session, create it with an empty hash
  def create_if_not_existing
    if !session.has_key? :basket
      session[:basket] = {}
    end
  end

  ##
  # Add an order to the basket with the wine id as the key and the quantity as
  # the value
  #
  # +order+ is a form submission of a wine to be added to the basket
  def add(order)
    create_if_not_existing

    # The form submits the param keys as strings, so we need to convert them
    # into symbols
    order.symbolize_keys
    session[:basket][order[:wine]] = order[:quantity].to_i
  end
end
