module Bill::CreditNoteFromCreditNoteId
  macro included
    {% unless @type.methods.any?(&.name.== :credit_note.id) %}
      getter credit_note : CreditNote? do
        credit_note_id.value.try do |value|
          CreditNoteQuery.new.id(value).first?
        end
      end
    {% end %}
  end
end
