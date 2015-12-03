class AddSupplierReferenceToWines < ActiveRecord::Migration
  def change
    add_reference :wines, :supplier, index: true, foreign_key: true
  end
end
