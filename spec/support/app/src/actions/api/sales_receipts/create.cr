class Api::SalesReceipts::Create < ApiAction
  include Bill::Api::SalesReceipts::Create

  post "/sales-receipts" do
    run_operation
  end
end
