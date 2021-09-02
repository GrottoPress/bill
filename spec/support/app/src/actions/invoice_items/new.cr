class InvoiceItems::New < BrowserAction
  include Bill::InvoiceItems::New

  get "/invoices/:invoice_id/line-items/new" do
    operation = CreateInvoiceItem.new(invoice_id: invoice_id.to_i64)
    html NewPage, operation: operation
  end
end
