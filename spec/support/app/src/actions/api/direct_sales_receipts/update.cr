class Api::DirectSalesReceipts::Update < ApiAction
  include Bill::Api::DirectSalesReceipts::Update

  patch "/direct-sales-receipts/:invoice_id" do
    run_operation
  end
end
