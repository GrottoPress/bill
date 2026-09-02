class Invoices::Edit < BrowserAction
  include Bill::Invoices::Edit

  get "/invoices/:invoice_id/edit" do
    operation = UpdateInvoice.new(invoice)

    html EditPage, operation: operation
  end
end
