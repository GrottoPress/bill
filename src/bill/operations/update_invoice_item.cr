module Bill::UpdateInvoiceItem
  macro included
    permit_columns :invoice_id, :description, :quantity, :price

    include Bill::SetPriceFromMu
    include Bill::ValidateInvoiceItem
  end
end
