class InvoiceItems::Edit < BrowserAction
  include Bill::InvoiceItems::Edit

  get "/invoices/line-items/:invoice_item_id/edit" do
    operation = UpdateInvoiceItem.new(invoice_item)
    html EditPage, operation: operation
  end
end
