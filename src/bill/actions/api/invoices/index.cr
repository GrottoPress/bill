module Bill::Api::Invoices::Index
  macro included
    # param page : Int32 = 1

    # get "/invoices" do
    #   json({
    #     status: "success",
    #     data: {invoices: InvoiceSerializer.for_collection(invoices)},
    #     pages: {
    #       current: page,
    #       total: pages.total
    #     }
    #   })
    # end

    def pages
      paginated_invoices[0]
    end

    getter invoices : Array(Invoice) do
      paginated_invoices[1].results
    end

    private getter paginated_invoices : Tuple(Lucky::Paginator, InvoiceQuery) do
      paginate(InvoiceQuery.new.preload_line_items.created_at.desc_order)
    end
  end
end
