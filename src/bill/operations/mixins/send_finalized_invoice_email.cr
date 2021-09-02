module Bill::SendFinalizedInvoiceEmail
  macro included
    after_commit send_email

    private def send_email(invoice : Bill::Invoice)
      return unless InvoiceStatus.now_finalized?(status)

      invoice = InvoiceQuery.preload_line_items(invoice)
      invoice = InvoiceQuery.preload_user(invoice)

      NewInvoiceEmail.new(self, invoice).deliver_later
    end
  end
end
