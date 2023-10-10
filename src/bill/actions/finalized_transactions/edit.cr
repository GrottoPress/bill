module Bill::FinalizedTransactions::Edit
  macro included
    # get "/transactions/:transaction_id/finalized/edit" do
    #   operation = UpdateFinalizedTransaction.new(transaction)
    #   html EditPage, operation: operation
    # end

    getter transaction : Transaction do
      TransactionQuery.find(transaction_id)
    end
  end
end
