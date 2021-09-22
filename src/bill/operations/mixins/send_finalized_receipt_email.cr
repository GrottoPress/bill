module Bill::SendFinalizedReceiptEmail
  macro included
    after_commit send_email

    private def send_email(receipt : Bill::Receipt)
      return unless ReceiptStatus.now_finalized?(status)

      receipt = ReceiptQuery.preload_user(receipt)
      NewReceiptEmail.new(self, receipt).deliver_later
    end
  end
end
