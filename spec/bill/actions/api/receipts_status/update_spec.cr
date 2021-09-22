require "../../../../spec_helper"

describe Bill::Api::ReceiptsStatus::Update do
  it "updates receipt status" do
    new_status = ReceiptStatus.new(:open)

    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id).status(:draft)

    response = ApiClient.exec(
      Api::ReceiptsStatus::Update.with(receipt_id: receipt.id),
      receipt: {status: new_status}
    )

    receipt.reload.status.should eq(new_status)
    response.should send_json(200, data: {receipt: {type: "ReceiptSerializer"}})
  end
end
