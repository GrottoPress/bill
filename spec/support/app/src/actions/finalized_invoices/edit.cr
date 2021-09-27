class FinalizedInvoices::Edit < BrowserAction
  include Bill::FinalizedInvoices::Edit

  get "/invoices/:invoice_id/finalized/edit" do
    operation = UpdateFinalizedInvoice.new(
      invoice,
      line_items: Array(Hash(String, String)).new
    )

    html EditPage, operation: operation
  end
end
