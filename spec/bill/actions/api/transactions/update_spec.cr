require "../../../../spec_helper"

describe Bill::Api::Transactions::Update do
  it "updates transaction" do
    new_description = "Another transaction"

    user = UserFactory.create

    transaction = TransactionFactory.create &.user_id(user.id)
      .description("New transaction")

    response = ApiClient.exec(
      Api::Transactions::Update.with(transaction_id: transaction.id),
      transaction: {description: new_description}
    )

    transaction.reload.description.should eq(new_description)
    response.should send_json(200, message: "action.transaction.update.success")
  end
end
