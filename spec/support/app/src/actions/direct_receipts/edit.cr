class DirectReceipts::Edit < BrowserAction
  include Bill::DirectReceipts::Edit

  get "/direct-receipts/:transaction_id/edit" do
    operation = UpdateDirectReceipt.new(transaction)
    html EditPage, operation: operation
  end
end
