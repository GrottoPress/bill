module Bill::CreateInvoiceItem
  macro included
    permit_columns :invoice_id, :description, :quantity, :price

    include Bill::SetPriceFromMu
    include Bill::ValidateParentRecord
    include Bill::ValidateInvoiceItem
  end
end
