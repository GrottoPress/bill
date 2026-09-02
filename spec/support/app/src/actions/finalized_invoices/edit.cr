class FinalizedInvoices::Edit < BrowserAction
  include Bill::FinalizedInvoices::Edit

  get "/invoices/:invoice_id/finalized/edit" do
    operation = UpdateFinalizedInvoice.new(invoice)

    html EditPage, operation: operation
  end
end
