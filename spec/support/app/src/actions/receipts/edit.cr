class Receipts::Edit < BrowserAction
  include Bill::Receipts::Edit

  get "/receipts/:receipt_id/edit" do
    operation = UpdateReceipt.new(receipt)
    html EditPage, operation: operation
  end
end
