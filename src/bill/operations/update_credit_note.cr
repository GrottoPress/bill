module Bill::UpdateCreditNote # CreditNote::SaveOperation
  macro included
    permit_columns :invoice_id, :description, :notes, :status

    before_save do
      validate_not_finalized
    end

    include Bill::SetFinalizedCreatedAt
    include Bill::SetReference
    include Bill::ValidateCreditNote

    {% if Avram::Model.all_subclasses.find(&.name.== :CreditNoteItem.id) %}
      include Bill::UpdateCreditNoteLineItems
      include Bill::FinalizeCreditNoteTotals
    {% end %}

    {% if Avram::Model.all_subclasses.find(&.name.== :Transaction.id) %}
      include Bill::CreateFinalizedCreditNoteTransaction
    {% end %}

    private def validate_not_finalized
      record.try do |credit_note|
        return unless credit_note.finalized?

        status.add_error Rex.t(
          :"operation.error.credit_note_finalized",
          id: credit_note.id,
          reference: credit_note.reference,
          status: credit_note.status.to_s
        )
      end
    end
  end
end
