class Receipt < BaseModel
  include Bill::Receipt
  include Bill::BelongsToUser

  table :receipts {}
end
