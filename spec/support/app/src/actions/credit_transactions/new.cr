class CreditTransactions::New < BrowserAction
  include Bill::CreditTransactions::New

  get "/transactions/credit/new" do
    operation = CreateCreditTransaction.new
    html NewPage, operation: operation
  end
end
