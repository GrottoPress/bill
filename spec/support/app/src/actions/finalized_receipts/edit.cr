class FinalizedReceipts::Edit < BrowserAction
  include Bill::FinalizedReceipts::Edit

  get "/receipts/:receipt_id/finalized/edit" do
    operation = UpdateFinalizedReceipt.new(receipt)
    html EditPage, operation: operation
  end
end
