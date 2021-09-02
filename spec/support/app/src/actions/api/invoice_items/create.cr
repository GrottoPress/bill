class Api::InvoiceItems::Create < ApiAction
  include Bill::Api::InvoiceItems::Create

  post "/invoices/:invoice_id/line-items" do
    run_operation
  end
end
