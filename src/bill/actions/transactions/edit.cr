module Bill::Transactions::Edit
  macro included
    # get "/transactions/:transaction_id/edit" do
    #   operation = UpdateTransaction.new(transaction)
    #   html EditPage, operation: operation
    # end

    getter transaction : Transaction do
      TransactionQuery.find(transaction_id)
    end
  end
end
