class ReceiptsStatus::Edit < BrowserAction
  include Bill::ReceiptsStatus::Edit

  get "/receipts/:receipt_id/status/edit" do
    operation = UpdateReceiptStatus.new(receipt)
    html EditPage, operation: operation
  end
end
