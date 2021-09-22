class Refunds::Create < BrowserAction
  include Bill::Refunds::Create

  post "/receipts/:receipt_id/refunds" do
    run_operation
  end
end
