module Bill::UpdateTransaction # Transaction::SaveOperation
  macro included
    permit_columns :user_id, :amount, :description, :source, :status, :type

    include Bill::SetAmountFromMu
    include Bill::SetFinalizedCreatedAt
    include Bill::SetReference
    include Bill::SetTransactionAmount

    before_save do
      validate_not_finalized
    end

    include Bill::ValidateTransaction

    {% if Avram::Model.all_subclasses.find(&.name.== :Invoice.id) %}
      include Bill::AutoMarkInvoicesAsPaid
    {% end %}

    private def validate_not_finalized
      record.try do |transaction|
        return unless transaction.finalized?

        status.add_error Rex.t(
          :"operation.error.transaction_finalized",
          id: transaction.id,
          reference: transaction.reference,
          status: transaction.status.to_s
        )
      end
    end
  end
end
