class ReceiptsStatus::Update < BrowserAction
  include Bill::ReceiptsStatus::Update

  patch "/receipts/:receipt_id/status" do
    run_operation
  end
end
