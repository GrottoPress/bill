class InvoicesStatus::Edit < BrowserAction
  include Bill::InvoicesStatus::Edit

  get "/invoices/:invoice_id/status/edit" do
    operation = UpdateInvoiceStatus.new(invoice)
    html EditPage, operation: operation
  end
end
