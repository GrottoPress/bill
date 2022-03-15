module Bill::Api::Receipts::Index
  macro included
    # param page : Int32 = 1

    # get "/receipts" do
    #   json ReceiptSerializer.new(receipts: receipts, pages: pages)
    # end

    def pages
      paginated_receipts[0]
    end

    getter receipts : Array(Receipt) do
      paginated_receipts[1].results
    end

    private getter paginated_receipts : Tuple(Lucky::Paginator, ReceiptQuery) do
      paginate(ReceiptQuery.new.created_at.desc_order)
    end
  end
end
