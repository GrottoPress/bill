module Bill
  Habitat.create do
    setting business_name : String
    setting business_address : String
    setting currency : ::Currency
    setting max_debt_allowed : Int32 = 0
  end
end
