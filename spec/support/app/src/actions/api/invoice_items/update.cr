class Api::InvoiceItems::Update < ApiAction
  include Bill::Api::InvoiceItems::Update

  patch "/invoices/line-items/:invoice_item_id" do
    run_operation
  end
end
