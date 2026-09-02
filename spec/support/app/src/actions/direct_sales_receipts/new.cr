class DirectSalesReceipts::New < BrowserAction
  include Bill::DirectSalesReceipts::New

  get "/direct-sales-receipts/new" do
    operation = CreateDirectSalesReceipt.new

    html NewPage, operation: operation
  end
end
