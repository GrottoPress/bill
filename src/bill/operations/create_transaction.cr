module Bill::CreateTransaction
  macro included
    permit_columns :user_id, :amount, :description, :status, :type

    attribute credit : Bool

    include Bill::SetDefaultStatus
    include Bill::SetAmountFromMu
    include Bill::SetReference

    before_save do
      set_amount

      validate_credit_required
    end

    include Bill::ValidateTransaction

    private def validate_credit_required
      validate_required credit,
        message: Rex.t(:"operation.error.credit_or_debit_required")
    end

    private def set_amount
      amount.value.try do |_amount|
        credit.value.try do |_credit|
          amount.value = _credit ? -_amount.abs : _amount.abs
        end
      end
    end
  end
end
