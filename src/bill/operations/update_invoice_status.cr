module Bill::UpdateInvoiceStatus
  macro included
    permit_columns :status

    include Bill::SetFinalizedCreatedAt
    include Bill::ValidateInvoice
    include Bill::ValidateHasLineItems
  end
end
