class Api::Transactions::Update < ApiAction
  include Bill::Api::Transactions::Update

  patch "/transactions/:transaction_id" do
    run_operation
  end
end
