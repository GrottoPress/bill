module Bill::UpdateReceiptStatus
  macro included
    permit_columns :status

    include Bill::SetFinalizedCreatedAt
    include Bill::ValidateReceipt
  end
end
