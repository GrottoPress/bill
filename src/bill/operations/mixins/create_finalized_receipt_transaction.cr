module Bill::CreateFinalizedReceiptTransaction
  macro included
    after_save create_transaction

    private def create_transaction(receipt : Bill::Receipt)
      return unless ReceiptStatus.now_finalized?(status)
      return if receipt.amount.zero?

      CreateCreditTransaction.create!(
        user_id: receipt.user_id,
        description: receipt.description,
        type: TransactionType.new(:receipt),
        amount: receipt.amount,
        metadata: JSON.parse({receipt_id: receipt.id}.to_json)
      )
    end
  end
end
