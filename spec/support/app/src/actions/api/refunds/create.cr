class Api::Refunds::Create < ApiAction
  include Bill::Api::Refunds::Create

  post "/receipts/:receipt_id/refunds" do
    run_operation
  end
end
