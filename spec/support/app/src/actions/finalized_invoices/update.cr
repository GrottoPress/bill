class FinalizedInvoices::Update < BrowserAction
  include Bill::FinalizedInvoices::Update

  patch "/invoices/:invoice_id/finalized" do
    run_operation
  end
end
