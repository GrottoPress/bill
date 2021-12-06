module Bill::DeleteReceipt
  macro included
    before_delete do
      validate_not_finalized
    end

    private def validate_not_finalized
      record.try do |receipt|
        return unless receipt.finalized?

        status.add_error Rex.t(
          :"operation.error.receipt_finalized",
          id: receipt.id,
          status: receipt.status.to_s
        )
      end
    end
  end
end
