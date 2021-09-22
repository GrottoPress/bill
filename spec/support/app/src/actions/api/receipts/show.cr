class Api::Receipts::Show < ApiAction
  include Bill::Api::Receipts::Show

  get "/receipts/:receipt_id" do
    json({
      status: "success",
      data: {receipt: ReceiptSerializer.new(receipt)}
    })
  end
end
