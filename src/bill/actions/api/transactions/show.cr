module Bill::Api::Transactions::Show
  macro included
    # get "/transactions/:transaction_id" do
    #   json ItemResponse.new(transaction: transaction)
    # end

    getter transaction : Transaction do
      TransactionQuery.find(transaction_id)
    end
  end
end
