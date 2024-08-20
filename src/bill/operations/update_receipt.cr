module Bill::UpdateReceipt # Receipt::SaveOperation
  macro included
    permit_columns :user_id, :amount, :description, :notes, :status

    before_save do
      validate_not_finalized
    end

    include Bill::SetAmountFromMu
    include Bill::SetFinalizedCreatedAt
    include Bill::SetBusinessDetails
    include Bill::SetUserDetails
    include Bill::SetReference
    include Bill::ValidateReceipt

    {% if Avram::Model.all_subclasses.find(&.name.== :Invoice.id) %}
      include Bill::ReceiveInvoicePayment
    {% end %}

    {% if Avram::Model.all_subclasses.find(&.name.== :Transaction.id) %}
      include Bill::CreateFinalizedReceiptTransaction
    {% end %}

    private def validate_not_finalized
      record.try do |receipt|
        return unless receipt.finalized?

        status.add_error Rex.t(
          :"operation.error.receipt_finalized",
          id: receipt.id,
          status: receipt.status.to_s
        )
      end
    end
  end
end
