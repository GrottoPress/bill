module Bill::CreditNoteTransactionMetadata
  macro included
    getter credit_note_id : CreditNote::PrimaryKeyType?
  end
end
