class Receipt < BaseModel
  include Bill::Receipt

  table :receipts {}
end
