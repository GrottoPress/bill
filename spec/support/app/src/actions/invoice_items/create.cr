class InvoiceItems::Create < BrowserAction
  include Bill::InvoiceItems::Create

  post "/invoices/:invoice_id/line-items" do
    run_operation
  end
end
