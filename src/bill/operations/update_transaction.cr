module Bill::UpdateTransaction
  macro included
    permit_columns :user_id, :amount, :description, :source, :status, :type

    include Bill::SetAmountFromMu
    include Bill::SetFinalizedCreatedAt
    include Bill::SetReference
    include Bill::SetTransactionAmount

    before_save do
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
  end
end
