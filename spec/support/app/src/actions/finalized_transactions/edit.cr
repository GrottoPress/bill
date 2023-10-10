class FinalizedTransactions::Edit < BrowserAction
  include Bill::FinalizedTransactions::Edit

  get "/transactions/:transaction_id/finalized/edit" do
    operation = UpdateFinalizedTransaction.new(transaction)
    html EditPage, operation: operation
  end
end
