class AddUpcToWines < ActiveRecord::Migration
  def change
    add_column :wines, :upc, :integer
    add_index :wines, :upc, unique: true
    change_column :wines, :size, :integer
  end
end
