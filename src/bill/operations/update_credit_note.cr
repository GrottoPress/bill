module Bill::UpdateCreditNote
  macro included
    permit_columns :invoice_id, :description, :notes, :status

    before_save do
      validate_not_finalized
    end

    include Bill::SetFinalizedCreatedAt
    include Bill::SetReference
    include Bill::ValidateCreditNote

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
