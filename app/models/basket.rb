# XXX: Delete file
class Basket
  include ActiveModel::Model

  def self.all
    return nil unless self.exist?
    session[:basket]
  end

  def self.fetch(wine)
    return nil unless self.exist?
    session[:basket].fetch wine
  end

  def self.add(order)
    create_if_not_existing
    session[:basket][order[:wine]] = {quantity: order[:quantity]}
  end

  def self.delete(wine)
    return unless self.exist?
    session[:basket].delete wine
  end

  def self.clear
    return unless self.exist?
    session[:basket].clear
  end

  private
  def self.exists?
    session.has_key? :basket
  end

  def self.create_if_not_existing
    if !exists?
      session[:basket] = {}
    end
  end
end
