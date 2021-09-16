class DebitTransactions::New < BrowserAction
  include Bill::DebitTransactions::New

  get "/transactions/debit/new" do
    operation = CreateDebitTransaction.new
    html NewPage, operation: operation
  end
end
