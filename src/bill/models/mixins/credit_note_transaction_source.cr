module Bill::CreditNoteTransactionSource
  macro included
    def credit_note_id : CreditNote::PrimaryKeyType?
      return unless type.credit_note?
      CreditNote::PrimaryKeyType.adapter.parse!(source)
    end

    def credit_note! : CreditNote?
      credit_note_id.try { |id| CreditNoteQuery.find(id) }
    end
  end
end
