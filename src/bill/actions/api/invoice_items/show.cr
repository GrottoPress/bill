module Bill::Api::InvoiceItems::Show
  macro included
    # get "/invoices/line-items/:invoice_item_id" do
    #   json InvoiceItemSerializer.new(invoice_item: invoice_item)
    # end

    getter invoice_item : InvoiceItem do
      InvoiceItemQuery.find(invoice_item_id)
    end
  end
end
