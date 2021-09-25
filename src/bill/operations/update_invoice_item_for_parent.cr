module Bill::UpdateInvoiceItemForParent
  macro included
    permit_columns :description, :quantity, :price

    include Bill::SetPriceFromMu
    include Bill::ValidateParentOperation
    include Bill::ValidateInvoiceItem
  end
end
