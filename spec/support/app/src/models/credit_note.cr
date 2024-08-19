class CreditNote < BaseModel
  include Bill::CreditNote
  include Bill::BelongsToInvoice
  include Bill::HasManyCreditNoteItems

  table :credit_notes {}
end
