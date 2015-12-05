class Wine < ActiveRecord::Base
  belongs_to :supplier

  validates :title, :size, :price, :country, :grape_type, presence: true
  validates :price, numericality: { greater_than: 0 }

  def self.search(query)
    where 'title LIKE ? OR country LIKE ? OR description LIKE ?',
      "%#{query}%", "%#{query}%", "%#{query}%"
  end
end
