module Bill::CreateCreditNote # CreditNote::SaveOperation
  macro included
    permit_columns :invoice_id, :description, :notes, :status

    include Bill::SetDefaultStatus
    include Bill::SetReference
    include Bill::ValidateCreditNote

    {% if Avram::Model.all_subclasses.any?(&.name.== :CreditNoteItem.id) %}
      include Bill::CreateCreditNoteLineItems
      include Bill::FinalizeCreditNoteTotals
    {% end %}

    {% if Avram::Model.all_subclasses.any?(&.name.== :Transaction.id) %}
      include Bill::CreateFinalizedCreditNoteTransaction
    {% end %}
  end
end
