module Bill::CreateFinalizedInvoiceTransaction
  macro included
    after_save create_transaction

    private def create_transaction(invoice : Bill::Invoice)
      return unless InvoiceStatus.now_finalized?(status)
      return if (amount = invoice.amount!).zero?

      CreateDebitTransaction.create!(
        user_id: invoice.user_id,
        description: invoice.description,
        type: TransactionType.new(:invoice),
        amount: amount,
        metadata: TransactionMetadata.from_json({
          invoice_id: invoice.id
        }.to_json)
      )
    end
  end
end
