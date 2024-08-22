class SalesReceipts::Edit < BrowserAction
  include Bill::SalesReceipts::Edit

  get "/sales-receipts/:invoice_id/edit" do
    operation = UpdateSalesReceipt.new(
      invoice,
      line_items: Array(Hash(String, String)).new
    )

    html EditPage, operation: operation
  end
end
