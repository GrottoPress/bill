class CreditNoteItem < BaseModel
  include Bill::CreditNoteItem
  include Bill::BelongsToCreditNote

  table :credit_note_items {}
end
