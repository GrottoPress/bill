class Api::ReceiptsStatus::Update < ApiAction
  include Bill::Api::ReceiptsStatus::Update

  patch "/receipts/:receipt_id/status" do
    run_operation
  end
end
