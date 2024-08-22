class DirectSalesReceipts::Update < BrowserAction
  include Bill::DirectSalesReceipts::Update

  patch "/direct-sales-receipts/:invoice_id" do
    run_operation
  end
end
