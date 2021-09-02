class InvoiceItems::Delete < BrowserAction
  include Bill::InvoiceItems::Delete

  delete "/invoices/line-items/:invoice_item_id" do
    run_operation
  end
end
