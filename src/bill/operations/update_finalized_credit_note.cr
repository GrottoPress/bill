module Bill::UpdateFinalizedCreditNote
  macro included
    permit_columns :description, :notes, :status

    before_save do
      validate_finalized
    end

    include Bill::ValidateCreditNote

    private def validate_finalized
      record.try do |credit_note|
        return if credit_note.finalized?

        status.add_error Rex.t(
          :"operation.error.credit_note_not_finalized",
          id: credit_note.id,
          status: credit_note.status.to_s
        )
      end
    end
  end
end
