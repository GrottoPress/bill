module Bill::Api::Invoices::Show
  macro included
    # get "/invoices/:invoice_id" do
    #   json InvoiceSerializer.new(invoice: invoice)
    # end

    getter invoice : Invoice do
      InvoiceQuery.new.preload_line_items.find(invoice_id)
    end
  end
end
