class CheckoutController < ApplicationController
  before_action :authenticate_customer!
end
