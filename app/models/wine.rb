class Wine < ActiveRecord::Base
  belongs_to :supplier

  validates :title, :size, :price, :country, :grape_type, presence: true
  validates :price, numericality: { greater_than: 0 }

  ##
  # Search through all of the available wines and fetch the ones that partially
  # match a given string
  #
  # +query+ contains a string to search for
  def self.search(query)
    where 'title LIKE ? OR country LIKE ? OR description LIKE ?',
      "%#{query}%", "%#{query}%", "%#{query}%"
  end
end
