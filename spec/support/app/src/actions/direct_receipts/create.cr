class DirectReceipts::Create < BrowserAction
  include Bill::DirectReceipts::Create

  post "/direct-receipts" do
    run_operation
  end
end
