class CheckoutController < ApplicationController
  before_action :authenticate_customer!

  def create
    submit_orders_to_suppliers current_customer, list_orders(session[:basket])

    redirect_to basket_index_path
  end

  private
  ##
  # Convert the +basket+ from the visitor's session into a hash of an
  # ActiveRecord of the wine and the quantity being ordered.
  def list_orders(basket)
    basket.inject([]) do |orders, (id, quantity)|
      orders << {
        wine: Wine.find(id),
        quantity: quantity
      }
    end
  end

  ##
  # Submits the orders to all of the suppliers.
  #
  # +customer+ is the ActiveRecord of a Customer
  # +orders+ is an array of hashes containing the user's orders
  def submit_orders_to_suppliers(customer, orders)
    raise ArgumentError unless customer.is_a? Customer and orders.is_a? Array

    # Submit each wine order to the revelant supplier
    orders.each do |order|
      RestClient.post "#{order[:wine].supplier.url}orders", {
        name: customer.name,
        address: customer.address,
        email: customer.email,
        upc: order[:wine].upc,
        quantity: order[:quantity]
      }.to_json, content_type: :json do |response|
        case response.code
        when 200, 201
          session[:basket].clear
        else
          #TODO: log an error
          puts 'error oh nooooo'
        end
      end
    end
  end
end
