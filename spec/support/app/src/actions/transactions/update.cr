class Transactions::Update < BrowserAction
  include Bill::Transactions::Update

  patch "/transactions/:transaction_id" do
    run_operation
  end
end
