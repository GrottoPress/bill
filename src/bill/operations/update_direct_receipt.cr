# Receives payment without creating a `Receipt` record
module Bill::UpdateDirectReceipt # Transaction::SaveOperation
  macro included
    before_save do
      set_type
      set_credit
    end

    {% if Avram::Model.all_subclasses.find(&.name.== :Invoice.id) %}
      include Bill::ReceiveDirectInvoicePayment
    {% end %}

    include Bill::UpdateTransaction

    private def set_type
      type.value = TransactionType.new(:receipt)
    end

    private def set_credit
      credit.value = true
    end
  end
end
