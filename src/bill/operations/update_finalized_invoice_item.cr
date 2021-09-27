module Bill::UpdateFinalizedInvoiceItem
  macro included
    permit_columns :description

    include Bill::ValidateInvoiceItem
    include Bill::ValidateParentFinalized
  end
end
