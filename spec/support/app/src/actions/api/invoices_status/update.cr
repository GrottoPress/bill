class Api::InvoicesStatus::Update < ApiAction
  include Bill::Api::InvoicesStatus::Update

  patch "/invoices/:invoice_id/status" do
    run_operation
  end
end
