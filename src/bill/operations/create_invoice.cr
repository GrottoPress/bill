module Bill::CreateInvoice # Invoice::SaveOperation
  macro included
    permit_columns :user_id, :description, :due_at, :notes, :status

    include Bill::SetDefaultStatus
    include Bill::EnsureDueAtGteCreatedAt
    include Bill::SetBusinessDetails
    include Bill::SetUserDetails
    include Bill::SetReference
    include Bill::ValidateInvoice

    {% if Avram::Model.all_subclasses.find(&.name.== :InvoiceItem.id) %}
      include Bill::CreateInvoiceLineItems
      include Bill::FinalizeInvoiceTotals
    {% end %}

    {% if Avram::Model.all_subclasses.find(&.name.== :Transaction.id) %}
      include Bill::CreateFinalizedInvoiceTransaction
    {% end %}
  end
end
