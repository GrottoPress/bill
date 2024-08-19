module Bill::UpdateInvoice # Invoice::SaveOperation
  macro included
    permit_columns :user_id, :description, :due_at, :notes, :status

    before_save do
      validate_not_finalized
    end

    include Bill::SetFinalizedCreatedAt
    include Bill::EnsureDueAtGteCreatedAt
    include Bill::SetBusinessDetails
    include Bill::SetUserDetails
    include Bill::SetReference
    include Bill::ValidateInvoice

    {% if Avram::Model.all_subclasses.find(&.name.== :InvoiceItem.id) %}
      include Bill::UpdateInvoiceLineItems
      include Bill::FinalizeInvoiceTotals
    {% end %}

    {% if Avram::Model.all_subclasses.find(&.name.== :Transaction.id) %}
      include Bill::CreateFinalizedInvoiceTransaction
    {% end %}

    private def validate_not_finalized
      record.try do |invoice|
        return unless invoice.finalized?

        status.add_error Rex.t(
          :"operation.error.invoice_finalized",
          id: invoice.id,
          status: invoice.status.to_s
        )
      end
    end
  end
end
