module Bill::Invoices::Show
  macro included
    # get "/invoices/:invoice_id" do
    #   html ShowPage, invoice: invoice
    # end

    getter invoice : Invoice do
      InvoiceQuery.new.preload_line_items.find(invoice_id)
    end
  end
end
