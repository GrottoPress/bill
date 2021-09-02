class Api::Invoices::Delete < ApiAction
  include Bill::Api::Invoices::Delete

  delete "/invoices/:invoice_id" do
    run_operation
  end
end
