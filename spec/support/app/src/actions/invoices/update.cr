class Invoices::Update < BrowserAction
  include Bill::Invoices::Update

  patch "/invoices/:invoice_id" do
    run_operation
  end
end
