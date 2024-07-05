module Bill::DeleteInvoiceItemForParent # InvoiceItem::DeleteOperation
  macro included
    include Bill::ValidateParentOperation
  end
end
