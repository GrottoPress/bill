class SalesReceipts::Create < BrowserAction
  include Bill::SalesReceipts::Create

  post "/sales-receipts" do
    run_operation
  end
end
