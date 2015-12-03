class WinesController < ApplicationController
  def index
    @wines = Wine.all
  end

  def show
    @wine = Wine.find(params[:id])
  end

  private
  def sync_with_suppliers
    supplier_data = []

    Supplier.all.each do |supplier|
      supplier_data << JSON.load(supplier.url)
    end

    supplier_data
  end
end
