module Bill::InvoiceDescription
  macro included
    private def invoice_description(invoice : Bill::Invoice)
      invoice.description || Rex.t(
        :"operation.misc.invoice_description",
        invoice_id: invoice.id,
        reference: invoice.reference
      )
    end
  end
end
