class DirectSalesReceipts::Edit < BrowserAction
  include Bill::DirectSalesReceipts::Edit

  get "/direct-sales-receipts/:invoice_id/edit" do
    operation = UpdateDirectSalesReceipt.new(invoice)

    html EditPage, operation: operation
  end
end
