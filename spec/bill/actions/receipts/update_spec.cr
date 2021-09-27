require "../../../spec_helper"

describe Bill::Receipts::Update do
  it "updates receipt" do
    new_description = "Another receipt"

    user = UserFactory.create

    receipt = ReceiptFactory.create &.user_id(user.id)
      .description("New receipt")
      .status(:draft)

    response = ApiClient.exec(
      Receipts::Update.with(receipt_id: receipt.id),
      receipt: {description: new_description}
    )

    receipt.reload.description.should eq(new_description)
    response.status.should eq(HTTP::Status::FOUND)
  end
end
