class DirectSalesReceipts::Create < BrowserAction
  include Bill::DirectSalesReceipts::Create

  post "/direct-sales-receipts" do
    run_operation
  end
end
