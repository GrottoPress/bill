class CreditNote < BaseModel
  include Bill::CreditNote
  include Bill::HasManyCreditNoteItems

  table :credit_notes {}
end
