require "../../../../spec_helper"

describe Bill::Api::DirectReceipts::Update do
  it "updates direct receipt" do
    new_description = "Another receipt"

    user = UserFactory.create

    transaction = TransactionFactory.create &.user_id(user.id)
      .description("New receipt")
      .status(:draft)

    response = ApiClient.exec(
      Api::DirectReceipts::Update.with(transaction_id: transaction.id),
      transaction: {description: new_description}
    )

    transaction.reload.description.should eq(new_description)
    response.should send_json(200, message: "action.receipt.update.success")
  end
end
