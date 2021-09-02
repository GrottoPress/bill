class Invoices::Edit < BrowserAction
  include Bill::Invoices::Edit

  get "/invoices/:invoice_id/edit" do
    operation = UpdateInvoice.new(
      invoice,
      line_items: Array(Hash(String, String)).new
    )

    html EditPage, operation: operation
  end
end
