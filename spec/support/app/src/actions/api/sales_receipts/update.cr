class Api::SalesReceipts::Update < ApiAction
  include Bill::Api::SalesReceipts::Update

  patch "/sales-receipts/:invoice_id" do
    run_operation
  end
end
