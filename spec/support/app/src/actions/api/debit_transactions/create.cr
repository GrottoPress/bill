class Api::DebitTransactions::Create < ApiAction
  include Bill::Api::DebitTransactions::Create

  post "/transactions/debit" do
    run_operation
  end
end
