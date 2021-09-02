class InvoicesStatus::Update < BrowserAction
  include Bill::InvoicesStatus::Update

  patch "/invoices/:invoice_id/status" do
    run_operation
  end
end
