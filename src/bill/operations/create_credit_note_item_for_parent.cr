module Bill::CreateCreditNoteItemForParent
  macro included
    permit_columns :description, :quantity, :price

    include Bill::SetPriceFromMu
    include Bill::ValidateParentOperation
    include Bill::ValidateCreditNoteItem
  end
end
