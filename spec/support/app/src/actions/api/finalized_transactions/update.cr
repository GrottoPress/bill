class Api::FinalizedTransactions::Update < ApiAction
  include Bill::Api::FinalizedTransactions::Update

  patch "/transactions/:transaction_id/finalized" do
    run_operation
  end
end
