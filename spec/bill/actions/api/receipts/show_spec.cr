require "../../../../spec_helper"

describe Bill::Api::Receipts::Show do
  it "shows receipt" do
    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id)

    response = ApiClient.exec(Api::Receipts::Show.with(receipt_id: receipt.id))

    response.should send_json(200, data: {receipt: {type: "ReceiptSerializer"}})
  end
end
