class Refunds::New < BrowserAction
  include Bill::Refunds::New

  get "/receipts/:receipt_id/refunds/new" do
    operation = RefundPayment.new(receipt: receipt)
    html NewPage, operation: operation
  end
end
