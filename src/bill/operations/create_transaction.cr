module Bill::CreateTransaction
  macro included
    permit_columns :user_id, :amount, :description, :status, :type

    include Bill::SetDefaultStatus
    include Bill::SetAmountFromMu
    include Bill::SetReference
    include Bill::SetTransactionAmount

    before_save do
      validate_credit_required
    end

    include Bill::ValidateTransaction

    private def validate_credit_required
      validate_required credit,
        message: Rex.t(:"operation.error.credit_or_debit_required")
    end
  end
end
