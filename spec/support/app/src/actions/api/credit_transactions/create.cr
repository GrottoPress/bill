class Api::CreditTransactions::Create < ApiAction
  include Bill::Api::CreditTransactions::Create

  post "/transactions/credit" do
    run_operation
  end
end
