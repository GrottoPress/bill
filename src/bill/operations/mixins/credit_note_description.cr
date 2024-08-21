module Bill::CreditNoteDescription
  macro included
    private def credit_note_description(credit_note : Bill::CreditNote)
      credit_note.description || Rex.t(
        :"operation.misc.credit_note_description",
        credit_note_id: credit_note.id,
        reference: credit_note.reference
      )
    end
  end
end
