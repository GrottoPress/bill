class CreditTransactions::Create < BrowserAction
  include Bill::CreditTransactions::Create

  post "/transactions/credit" do
    run_operation
  end
end
