class SyncWithSuppliersJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Supplier.all.each do |supplier|
      # Contact a supplier to get a list of wines they sell
      json = JSON.parse(RestClient.get("#{supplier.url}products", {:accept => :json}))

      # Insert each wine into the database if either:
      #   - there are no wines currently in the db with a matching upc
      #   - there is already a wine in the db with a matching upc but the price
      #     is lower
      json['data']['wines'].each do |wine|
        create_or_update_wine wine
      end
    end
  end

  def create_or_update_wine(supplier_wine)
    #TODO: Need to also delete wines that aren't present in either supplier
    begin
      local_wine = Wine.find_by! upc: supplier_wine.upc
      local_wine.update supplier_wine
    rescue
      local_wine.create supplier_wine
    end
  end
end
