module Bill::CreditNoteFromCreditNoteId
  macro included
    getter credit_note : CreditNote? do
      credit_note_id.value.try { |value| CreditNoteQuery.new.id(value).first? }
    end
  end
end
