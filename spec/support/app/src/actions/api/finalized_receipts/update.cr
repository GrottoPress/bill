class Api::FinalizedReceipts::Update < ApiAction
  include Bill::Api::FinalizedReceipts::Update

  patch "/receipts/:receipt_id/finalized" do
    run_operation
  end
end
