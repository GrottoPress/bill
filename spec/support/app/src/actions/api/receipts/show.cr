class Api::Receipts::Show < ApiAction
  include Bill::Api::Receipts::Show

  get "/receipts/:receipt_id" do
    json ReceiptSerializer.new(receipt: receipt)
  end
end
