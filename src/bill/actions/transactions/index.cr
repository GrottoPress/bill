module Bill::Transactions::Index
  macro included
    # param page : Int32 = 1

    # get "/transactions" do
    #   html IndexPage, transactions: transactions, pages: pages
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
