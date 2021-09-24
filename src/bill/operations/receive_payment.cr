module Bill::ReceivePayment
  macro included
    permit_columns :user_id, :amount, :description, :notes, :status

    include Bill::SetDefaultStatus
    include Bill::SetAmountFromMu
    include Bill::SetBusinessDetails
    include Bill::SetUserDetails
    include Bill::ValidateReceipt
  end
end
