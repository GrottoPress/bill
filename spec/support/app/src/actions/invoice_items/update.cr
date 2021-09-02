class InvoiceItems::Update < BrowserAction
  include Bill::InvoiceItems::Update

  patch "/invoices/line-items/:invoice_item_id" do
    run_operation
  end
end
