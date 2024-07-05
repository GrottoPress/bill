module Bill::CreateInvoiceItemForParent # InvoiceItem::SaveOperation
  macro included
    permit_columns :description, :quantity, :price

    include Bill::SetPriceFromMu
    include Bill::ValidateParentOperation
    include Bill::ValidateInvoiceItem
  end
end
