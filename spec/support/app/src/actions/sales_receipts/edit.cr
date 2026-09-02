class SalesReceipts::Edit < BrowserAction
  include Bill::SalesReceipts::Edit

  get "/sales-receipts/:invoice_id/edit" do
    operation = UpdateSalesReceipt.new(invoice)

    html EditPage, operation: operation
  end
end
