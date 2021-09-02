module Bill::Api::InvoiceItems::Show
  macro included
    # get "/invoices/line-items/:invoice_item_id" do
    #   json({
    #     status: "success",
    #     data: {invoice_item: InvoiceItemSerializer.new(invoice_item)}
    #   })
    # end

    getter invoice_item : InvoiceItem do
      InvoiceItemQuery.find(invoice_item_id)
    end
  end
end
