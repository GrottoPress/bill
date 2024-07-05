module Bill::DeleteCreditNote # CreditNote::DeleteOperation
  macro included
    before_delete do
      validate_not_finalized
    end

    private def validate_not_finalized
      record.try do |credit_note|
        return unless credit_note.finalized?

        status.add_error Rex.t(
          :"operation.error.credit_note_finalized",
          id: credit_note.id,
          status: credit_note.status.to_s
        )
      end
    end
  end
end
