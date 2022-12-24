class Transactions::Edit < BrowserAction
  include Bill::Transactions::Edit

  get "/transactions/:transaction_id/edit" do
    operation = UpdateTransaction.new(transaction)
    html EditPage, operation: operation
  end
end
