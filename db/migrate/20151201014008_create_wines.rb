class CreateWines < ActiveRecord::Migration
  def change
    create_table :wines do |t|
      t.string :title
      t.string :size
      t.decimal :price, precision: 8, scale: 2
      t.string :country
      t.string :grape_type
      t.boolean :vegetarian
      t.text :longdesc

      t.timestamps null: false
    end
  end
end
