module Bill::UpdateFinalizedInvoiceItem # InvoiceItem::SaveOperation
  macro included
    permit_columns :description

    include Bill::ValidateInvoiceItem
    include Bill::ValidateParentFinalized
  end
end
