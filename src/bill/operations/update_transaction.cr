module Bill::UpdateTransaction
  macro included
    permit_columns :user_id, :amount, :description, :status, :type

    attribute credit : Bool

    include Bill::SetAmountFromMu
    include Bill::SetFinalizedCreatedAt
    include Bill::SetReference

    before_save do
      set_credit
      set_amount

      validate_not_finalized
    end

    include Bill::ValidateTransaction

    private def validate_not_finalized
      record.try do |transaction|
        return unless transaction.finalized?

        status.add_error Rex.t(
          :"operation.error.transaction_finalized",
          id: transaction.id,
          status: transaction.status.to_s
        )
      end
    end

    private def set_amount
      amount.value.try do |_amount|
        credit.value.try do |_credit|
          amount.value = _credit ? -_amount.abs : _amount.abs
        end
      end
    end

    private def set_credit
      return unless credit.value.nil?
      record.try { |transaction| credit.value = transaction.credit? }
    end
  end
end
