module Bill::Transactions::Show
  macro included
    # get "/transactions/:transaction_id" do
    #   html ShowPage, transaction: transaction
    # end

    getter transaction : Transaction do
      TransactionQuery.find(transaction_id)
    end
  end
end
