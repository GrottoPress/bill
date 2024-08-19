class Receipts::New < BrowserAction
  include Bill::Receipts::New

  get "/receipts/new" do
    operation = CreateReceipt.new
    html NewPage, operation: operation
  end
end
