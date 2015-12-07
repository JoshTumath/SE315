class SyncWithSuppliersJob < ActiveJob::Base
  require 'rest-client'
  require 'data_uri'

  queue_as :default

  def perform(*args)
    #TODO: Abort if it's been less than 2 minutes since the last check

    # Build up a list of the cheapest wines from all of the suppliers
    extract_cheapest_wines(collate_all_supplier_wines).each do |upc, wine|
      create_or_update_wine wine
    end
  end

  private
  ##
  # Request all of the stock of each supplier and return all of the suppliers'
  # wines in an array
  def collate_all_supplier_wines
    suppliers = []

    Supplier.all.each do |supplier|
      # Contact a supplier to get a list of wines they sell
      RestClient.get supplier.url, {accept: :json, timeout: 10} do |response|
        case response.code
        when 200
          json = JSON.parse response.body, symbolize_names: true

          suppliers << add_supplier_id_to_wines(supplier.id, json[:data][:wines])
        else
          #TODO: log an error
          print 'error oh nooooo'
        end
      end
    end

    suppliers
  end

  ##
  # Add an additional record to the array of hashes for the wines containing the
  # supplier's id
  def add_supplier_id_to_wines(supplier_id, wines)
    wines.map do |wine|
      wine[:supplier] = Supplier.find(supplier_id)
      wine
    end
  end

  ##
  # Creates an array of only the cheapest wines. If multiple wines have the same
  # upc, the cheapest one is chosen.
  #
  # Requires a list of +suppliers+, which each contain a list of their own wines
  def extract_cheapest_wines(suppliers)
    suppliers.flatten.inject({}) do |cheapest_wines, wine|
      # Check if this wine is not already in the list, or if it's cheaper than
      # the wine that is already in the list
      if !cheapest_wines.has_key? wine[:id] or
      wine[:price] < cheapest_wines[wine[:id]][:price]
        cheapest_wines[wine[:id]] = wine
      end

      cheapest_wines
    end
  end

  ##
  # Updates the database with the data described in +supplier_wine+.
  def create_or_update_wine(supplier_wine)
    #TODO: Supplier comparison logic
    #TODO: Need to also delete wines that aren't present in either supplier
    begin
      # Try and find the wine in the db. If it's there, update the row with
      # supplier_wine
      local_wine = Wine.find_by! upc: supplier_wine[:upc]

      # We don't want the image to be stored in the db, so we remove it from
      # the supplier_wine and save it in the filesystem
      save_image supplier_wine[:upc], supplier_wine.delete(:image)

      local_wine.update supplier_wine
    rescue
      # If the wine could not be found, then a new row will be created

      # We don't want the image to be stored in the db, so we remove it from
      # the supplier_wine and save it in the filesystem
      save_image supplier_wine[:upc], supplier_wine.delete(:image)

      Wine.create supplier_wine
    end
  end

  ##
  # Saves an image into public/images/wines/.
  #
  # The image must be represented as a data URI and passed into +data_uri+
  def save_image(upc, data_uri)
    uri = URI::Data.new(data_uri)

    case uri.content_type
    when 'image/jpeg'
      extension = 'jpg'
    when 'image/png'
      extension = 'png'
    else
      raise ArgumentError, 'Image type not supported'
    end

    File.write "public/images/wines/#{upc}.#{extension}", 'foo' #uri.data
  end
end
