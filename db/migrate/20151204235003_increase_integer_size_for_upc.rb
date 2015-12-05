class IncreaseIntegerSizeForUpc < ActiveRecord::Migration
  def change
    change_column :wines, :upc, :integer, limit: 8
  end
end
