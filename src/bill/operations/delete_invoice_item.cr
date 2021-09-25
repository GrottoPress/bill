module Bill::DeleteInvoiceItem
  macro included
    include Bill::ValidateParentRecord
  end
end
