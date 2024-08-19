class DirectReceipts::New < BrowserAction
  include Bill::DirectReceipts::New

  get "/direct-receipts/new" do
    operation = CreateDirectReceipt.new
    html NewPage, operation: operation
  end
end
