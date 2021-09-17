module Bill::DeleteCreditNoteItem
  macro included
    before_delete do
      validate_not_finalized
    end

    private def validate_not_finalized
      return unless record.credit_note.finalized?
      credit_note_id.add_error("is finalized")
    end
  end
end
