class SalesReceipts::New < BrowserAction
  include Bill::SalesReceipts::New

  get "/sales-receipts/new" do
    operation = CreateSalesReceipt.new

    html NewPage, operation: operation
  end
end
