module Bill::DeleteInvoiceItemForParent
  macro included
    include Bill::ValidateParentOperation
  end
end
