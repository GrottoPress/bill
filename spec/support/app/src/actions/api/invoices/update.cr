class Api::Invoices::Update < ApiAction
  include Bill::Api::Invoices::Update

  patch "/invoices/:invoice_id" do
    run_operation
  end
end
