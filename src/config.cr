module Bill
  Habitat.create do
    setting business_name : String
    setting business_address : String
    setting currency : ::Currency
  end
end
