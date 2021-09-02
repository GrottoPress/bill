module Bill::InvoiceItems::Index
  macro included
    # param page : Int32 = 1

    # get "/invoices/:invoice_id/line-items" do
    #   html IndexPage, invoice_items: invoice_items, pages: pages
    # end

    def pages
      paginated_invoice_items[0]
    end

    getter invoice_items : Array(InvoiceItem) do
      paginated_invoice_items[1].results
    end

    private getter paginated_invoice_items : Tuple(
      Lucky::Paginator,
      InvoiceItemQuery
    ) do
      paginate InvoiceItemQuery.new.invoice_id(invoice_id).created_at.desc_order
    end
  end
end
