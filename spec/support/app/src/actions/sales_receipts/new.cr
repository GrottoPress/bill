class SalesReceipts::New < BrowserAction
  include Bill::SalesReceipts::New

  get "/sales-receipts/new" do
    operation = CreateSalesReceipt.new(
      line_items: Array(Hash(String, String)).new
    )

    html NewPage, operation: operation
  end
end
