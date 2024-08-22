class Api::DirectSalesReceipts::Create < ApiAction
  include Bill::Api::DirectSalesReceipts::Create

  post "/direct-sales-receipts" do
    run_operation
  end
end
