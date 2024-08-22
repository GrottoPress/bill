# A sales receipt is an invoice paid for on the spot.
#
# Creates invoice, and marks the invoice as paid.
# (No `Receipt` record is created, only a receipt `Transaction`)
module Bill::CreateDirectSalesReceipt # Invoice::SaveOperation
  macro included
    include Bill::InvoiceDescription
    include Bill::CreateInvoice

    after_save create_receipt

    private def create_receipt(invoice : Bill::Invoice)
      return unless InvoiceStatus.now_finalized?(status)

      CreateDirectReceipt.create!(
        invoice_id: invoice.id,
        user_id: invoice.user_id,
        description: invoice_description(invoice),
        amount: invoice.net_amount!,
        status: TransactionStatus.new(:open)
      )

      self.record = self.record.try(&.reload)
    end
  end
end
