class Api::InvoiceItems::Delete < ApiAction
  include Bill::Api::InvoiceItems::Delete

  delete "/invoices/line-items/:invoice_item_id" do
    run_operation
  end
end
