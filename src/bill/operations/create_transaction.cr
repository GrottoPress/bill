module Bill::CreateTransaction
  macro included
    permit_columns :user_id, :amount, :description, :type

    include Bill::SetAmountFromMu
    include Bill::EnsureCreatedAtNotPast
    include Bill::ValidateTransaction
  end
end
