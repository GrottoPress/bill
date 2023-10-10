require "../../../spec_helper"

describe Bill::FinalizedTransactions::Update do
  it "updates finalized transaction" do
    new_description = "Another transaction"

    user = UserFactory.create
    transaction = TransactionFactory.create &.user_id(user.id).status(:open)

    response = ApiClient.exec(
      FinalizedTransactions::Update.with(transaction_id: transaction.id),
      transaction: {description: new_description}
    )

    transaction.reload.description.should eq(new_description)
    response.status.should eq(HTTP::Status::FOUND)
  end
end
