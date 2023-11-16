module Bill::SendDirectReceiptEmail
  macro included
    after_commit send_receipt_email

    private def send_receipt_email(transaction : Bill::Transaction)
      return unless TransactionStatus.now_finalized?(status)
      return unless transaction.type == TransactionType.new(:receipt)

      transaction = TransactionQuery.preload_user(transaction)
      NewDirectReceiptEmail.new(self, transaction).deliver_later
    end
  end
end
