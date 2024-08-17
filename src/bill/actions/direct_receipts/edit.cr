module Bill::DirectReceipts::Edit
  macro included
    # get "/receipts/:transaction_id/edit" do
    #   operation = UpdateDirectReceipt.new(transaction)
    #   html EditPage, operation: operation
    # end

    getter transaction : Transaction do
      TransactionQuery.find(transaction_id)
    end
  end
end
