class SalesReceipts::Update < BrowserAction
  include Bill::SalesReceipts::Update

  patch "/sales-receipts/:invoice_id" do
    run_operation
  end
end
