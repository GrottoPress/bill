module Bill::FinalizedInvoices::Edit
  macro included
    # get "/invoices/:invoice_id/finalized/edit" do
    #   operation = UpdateFinalizedInvoice.new(
    #     invoice,
    #     line_items: Array(Hash(String, String)).new
    #   )
    #
    #   html EditPage, operation: operation
    # end

    getter invoice : Invoice do
      InvoiceQuery.new.preload_line_items.find(invoice_id)
    end
  end
end
