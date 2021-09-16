class DebitTransactions::Create < BrowserAction
  include Bill::DebitTransactions::Create

  post "/transactions/debit" do
    run_operation
  end
end
