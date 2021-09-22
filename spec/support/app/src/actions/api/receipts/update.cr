class Api::Receipts::Update < ApiAction
  include Bill::Api::Receipts::Update

  patch "/receipts/:receipt_id" do
    run_operation
  end
end
