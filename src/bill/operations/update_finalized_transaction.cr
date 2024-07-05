module Bill::UpdateFinalizedTransaction # Transaction::SaveOperation
  macro included
    permit_columns :description, :status

    before_save do
      validate_finalized
    end

    include Bill::ValidateTransaction

    private def validate_finalized
      record.try do |transaction|
        return if transaction.finalized?

        status.add_error Rex.t(
          :"operation.error.transaction_not_finalized",
          id: transaction.id,
          status: transaction.status.to_s
        )
      end
    end
  end
end
