module Bill::CreateFinalizedReceiptTransaction
  macro included
    after_save create_transaction

    private def create_transaction(receipt : Bill::Receipt)
      return unless ReceiptStatus.now_finalized?(status)
      return if receipt.amount.zero?

      CreateTransaction.create!(
        user_id: receipt.user_id,
        credit: true,
        description: receipt.description,
        type: TransactionType.new(:receipt),
        status: TransactionStatus.new(:open),
        amount: receipt.amount,
        source: receipt.id.to_s
      )
    end
  end
end
