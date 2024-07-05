module Bill::UpdateFinalizedReceipt # Receipt::SaveOperation
  macro included
    permit_columns :description, :notes, :status

    before_save do
      validate_finalized
    end

    include Bill::ValidateReceipt

    private def validate_finalized
      record.try do |receipt|
        return if receipt.finalized?

        status.add_error Rex.t(
          :"operation.error.receipt_not_finalized",
          id: receipt.id,
          status: receipt.status.to_s
        )
      end
    end
  end
end
