module Bill::CreateReceipt # Receipt::SaveOperation
  macro included
    permit_columns :user_id, :amount, :description, :notes, :status

    include Bill::SetDefaultStatus
    include Bill::SetAmountFromMu
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
  end
end
