class DirectReceipts::Update < BrowserAction
  include Bill::DirectReceipts::Update

  patch "/direct-receipts/:transaction_id" do
    run_operation
  end
end
