class Api::DirectReceipts::Update < ApiAction
  include Bill::Api::DirectReceipts::Update

  patch "/direct-receipts/:transaction_id" do
    run_operation
  end
end
