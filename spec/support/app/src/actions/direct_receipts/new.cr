class DirectReceipts::New < BrowserAction
  include Bill::DirectReceipts::New

  get "/direct-receipts/new" do
    operation = ReceiveDirectPayment.new
    html NewPage, operation: operation
  end
end
