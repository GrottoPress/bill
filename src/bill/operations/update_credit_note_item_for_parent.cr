module Bill::UpdateCreditNoteItemForParent
  macro included
    permit_columns :description, :quantity, :price

    include Bill::SetPriceFromMu
    include Bill::ValidateParentOperation
    include Bill::ValidateCreditNoteItem
  end
end
