class Wine < ActiveRecord::Base
  validates :title, :size, :price, :country, :grape_type, presence: true
  validates :price, numericality: { greater_than: 0 }
end
