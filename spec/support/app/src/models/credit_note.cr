class CreditNote < BaseModel
  include Bill::CreditNote

  table :credit_notes {}
end
