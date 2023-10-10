require "../../../../spec_helper"

describe Bill::Api::FinalizedTransactions::Update do
  it "updates finalized transaction" do
    new_description = "Another transaction"

    user = UserFactory.create
    transaction = TransactionFactory.create &.user_id(user.id).status(:open)

    response = ApiClient.exec(
      Api::FinalizedTransactions::Update.with(transaction_id: transaction.id),
      transaction: {description: new_description}
    )

    transaction.reload.description.should eq(new_description)
    response.should send_json(200, message: "action.transaction.update.success")
  end
end
