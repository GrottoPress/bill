module Bill::UpdateReceipt
  macro included
    permit_columns :user_id, :amount, :description, :notes, :status

    include Bill::SetAmountFromMu
    include Bill::SetFinalizedCreatedAt
    include Bill::SetBusinessDetails
    include Bill::SetUserDetails
    include Bill::ValidateReceipt
    include Bill::ValidateNotFinalized
  end
end
