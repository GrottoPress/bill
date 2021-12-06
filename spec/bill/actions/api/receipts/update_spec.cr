require "../../../../spec_helper"

describe Bill::Api::Receipts::Update do
  it "updates receipt" do
    new_description = "Another receipt"

    user = UserFactory.create

    receipt = ReceiptFactory.create &.user_id(user.id)
      .description("New receipt")
      .status(:draft)

    response = ApiClient.exec(
      Api::Receipts::Update.with(receipt_id: receipt.id),
      receipt: {description: new_description}
    )

    receipt.reload.description.should eq(new_description)
    response.should send_json(200, message: "action.receipt.update.success")
  end
end
