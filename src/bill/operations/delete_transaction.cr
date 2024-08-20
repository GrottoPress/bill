module Bill::DeleteTransaction # Transaction::DeleteOperation
  macro included
    before_delete do
      validate_not_finalized
    end

    private def validate_not_finalized
      record.try do |transaction|
        return unless transaction.finalized?

        status.add_error Rex.t(
          :"operation.error.transaction_finalized",
          id: transaction.id,
          reference: transaction.reference,
          status: transaction.status.to_s
        )
      end
    end
  end
end
