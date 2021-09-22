class Api::Receipts::Delete < ApiAction
  include Bill::Api::Receipts::Delete

  delete "/receipts/:receipt_id" do
    run_operation
  end
end
