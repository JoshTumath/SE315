class CheckoutController < ApplicationController
  before_action :authenticate_customer!

  def create
    submit_orders_to_suppliers current_customer, list_orders(session[:basket])

    redirect_to basket_index_path
  end

  def list_orders(basket)
    basket.inject([]) do |orders, (id, quantity)|
      orders << {
        wine: Wine.find(id),
        quantity: quantity
      }
    end
  end

  def submit_orders_to_suppliers(customer, orders)
    raise ArgumentError unless customer.is_a? Customer and orders.is_a? Array

    orders.each do |order|
      RestClient.post order[:wine].supplier.url, {
        name: customer.name,
        address: customer.address,
        email: customer.email,
        upc: order[:wine].upc,
        quantity: order[:quantity]
      }.to_json, content_type: :json do |response|
        case response.code
        when 200
          session[:basket].clear
        else
          #TODO: log an error
          puts 'error oh nooooo'
        end
      end
    end
  end
end
