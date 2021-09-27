class Api::FinalizedInvoices::Update < ApiAction
  include Bill::Api::FinalizedInvoices::Update

  patch "/invoices/:invoice_id/finalized" do
    run_operation
  end
end
