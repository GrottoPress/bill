class FinalizedReceipts::Update < BrowserAction
  include Bill::FinalizedReceipts::Update

  patch "/receipts/:receipt_id/finalized" do
    run_operation
  end
end
