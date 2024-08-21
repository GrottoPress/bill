module Bill::CreateFinalizedInvoiceTransaction
  macro included
    include Bill::InvoiceDescription

    after_save create_transaction

    private def create_transaction(invoice : Bill::Invoice)
      return unless InvoiceStatus.now_finalized?(status)
      return if (amount = invoice.amount!).zero?

      CreateTransaction.create!(
        user_id: invoice.user_id,
        credit: false,
        description: invoice_description(invoice),
        type: TransactionType.new(:invoice),
        status: TransactionStatus.new(:open),
        amount: amount,
        source: invoice.id.to_s
      )
    end
  end
end
