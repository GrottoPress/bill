module Bill::FinalizeInvoiceTotals
  macro included
    after_save update_totals

    private def update_totals(invoice : Bill::Invoice)
      return unless InvoiceStatus.now_finalized?(status)
      UpdateInvoiceTotals.update!(invoice)
    end
  end
end
