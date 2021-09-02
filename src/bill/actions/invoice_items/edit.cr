module Bill::InvoiceItems::Edit
  macro included
    # get "/invoices/line-items/:invoice_item_id/edit" do
    #   operation = UpdateInvoiceItem.new(invoice_item)
    #   html EditPage, operation: operation
    # end

    getter invoice_item : InvoiceItem do
      InvoiceItemQuery.find(invoice_item_id)
    end
  end
end
