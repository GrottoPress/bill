module Bill::CreateTransaction
  macro included
    permit_columns :user_id, :amount, :description, :status, :type

    include Bill::SetDefaultStatus
    include Bill::SetAmountFromMu
    include Bill::SetReference
    include Bill::ValidateTransaction
  end
end
