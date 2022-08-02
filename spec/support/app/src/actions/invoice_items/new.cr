class InvoiceItems::New < BrowserAction
  include Bill::InvoiceItems::New

  get "/invoices/:invoice_id/line-items/new" do
    operation = CreateInvoiceItem.new(invoice_id: _invoice_id)
    html NewPage, operation: operation
  end
end
