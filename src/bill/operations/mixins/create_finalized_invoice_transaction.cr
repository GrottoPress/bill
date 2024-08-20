module Bill::CreateFinalizedInvoiceTransaction
  macro included
    after_save create_transaction

    private def create_transaction(invoice : Bill::Invoice)
      return unless InvoiceStatus.now_finalized?(status)
      return if (amount = invoice.amount!).zero?

      description = invoice.description || Rex.t(
        :"operation.misc.invoice_description",
        invoice_id: invoice.id,
        reference: invoice.reference
      )

      CreateTransaction.create!(
        user_id: invoice.user_id,
        credit: false,
        description: description,
        type: TransactionType.new(:invoice),
        status: TransactionStatus.new(:open),
        amount: amount,
        source: invoice.id.to_s
      )
    end
  end
end
