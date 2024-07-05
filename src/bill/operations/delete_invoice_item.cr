module Bill::DeleteInvoiceItem # InvoiceItem::DeleteOperation
  macro included
    include Bill::ValidateParentRecord
  end
end
