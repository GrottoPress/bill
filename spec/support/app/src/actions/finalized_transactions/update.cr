class FinalizedTransactions::Update < BrowserAction
  include Bill::FinalizedTransactions::Update

  patch "/transactions/:transaction_id/finalized" do
    run_operation
  end
end
