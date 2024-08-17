class Api::DirectReceipts::Create < ApiAction
  include Bill::Api::DirectReceipts::Create

  post "/direct-receipts" do
    run_operation
  end
end
