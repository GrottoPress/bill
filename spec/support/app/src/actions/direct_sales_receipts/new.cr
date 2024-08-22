class DirectSalesReceipts::New < BrowserAction
  include Bill::DirectSalesReceipts::New

  get "/direct-sales-receipts/new" do
    operation = CreateDirectSalesReceipt.new(
      line_items: Array(Hash(String, String)).new
    )

    html NewPage, operation: operation
  end
end
