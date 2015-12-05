class RenameLongdescInSuppliers < ActiveRecord::Migration
  def change
    rename_column :wines, :longdesc, :description
  end
end
