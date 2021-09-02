module Bill::InvoicesStatus::Edit
  macro included
    # get "/invoices/:invoice_id/status/edit" do
    #   operation = UpdateInvoiceStatus.new(invoice)
    #   html EditPage, operation: operation
    # end

    getter invoice : Invoice do
      InvoiceQuery.find(invoice_id)
    end
  end
end
