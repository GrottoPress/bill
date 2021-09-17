class CreditNoteItem < BaseModel
  include Bill::CreditNoteItem

  table :credit_note_items {}
end
