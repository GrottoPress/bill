Bill.configure do |settings|
  settings.business_name = "ACME Inc"
  settings.business_address = "123 Joe Boy Street, Antarctica."
  settings.currency = Currency.new("GHS", "GH₵")
end
