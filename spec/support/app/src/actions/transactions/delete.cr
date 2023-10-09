class Transactions::Delete < BrowserAction
  include Bill::Transactions::Delete

  delete "/transactions/:transaction_id" do
    run_operation
  end
end
