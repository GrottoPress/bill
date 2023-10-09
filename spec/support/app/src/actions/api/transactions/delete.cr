class Api::Transactions::Delete < ApiAction
  include Bill::Api::Transactions::Delete

  delete "/transactions/:transaction_id" do
    run_operation
  end
end
