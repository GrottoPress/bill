require "../../../../spec_helper"

describe Bill::Api::FinalizedReceipts::Update do
  it "updates finalized receipt" do
    new_description = "Another receipt"

    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id).status(:open)

    response = ApiClient.exec(
      Api::FinalizedReceipts::Update.with(receipt_id: receipt.id),
      receipt: {description: new_description}
    )

    receipt.reload.description.should eq(new_description)
    response.should send_json(200, message: "action.receipt.update.success")
  end
end
