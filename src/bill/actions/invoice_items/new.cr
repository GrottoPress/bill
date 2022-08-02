module Bill::InvoiceItems::New
  macro included
    # get "/invoices/:invoice_id/line-items/new" do
    #   operation = CreateInvoiceItem.new(invoice_id: _invoice_id)
    #   html NewPage, operation: operation
    # end

    private def _invoice_id
      Invoice::PrimaryKeyType.adapter.parse!(invoice_id)
    end
  end
end
