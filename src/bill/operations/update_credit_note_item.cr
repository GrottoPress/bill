module Bill::UpdateCreditNoteItem
  macro included
    permit_columns :credit_note_id, :description, :quantity, :price

    include Bill::SetPriceFromMu
    include Bill::ValidateParentRecord
    include Bill::ValidateCreditNoteItem
  end
end
