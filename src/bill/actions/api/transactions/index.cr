module Bill::Api::Transactions::Index
  macro included
    # param page : Int32 = 1

    # get "/transactions" do
    #   json({
    #     status: "success",
    #     data: {
    #       transactions: TransactionSerializer.for_collection(transactions)
    #     },
    #     pages: {
    #       current: page,
    #       total: pages.total
    #     }
    #   })
    # end

    def pages
      paginated_transactions[0]
    end

    getter transactions : Array(Transaction) do
      paginated_transactions[1].results
    end

    private getter paginated_transactions : Tuple(
      Lucky::Paginator,
      TransactionQuery
    ) do
      paginate(TransactionQuery.new.created_at.desc_order)
    end
  end
end
