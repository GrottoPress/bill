module Bill::UpdateReceiptStatus
  macro included
    permit_columns :status

    include Bill::SetFinalizedCreatedAt
    include Bill::SetBusinessDetails
    include Bill::SetUserDetails
    include Bill::ValidateReceipt
  end
end
