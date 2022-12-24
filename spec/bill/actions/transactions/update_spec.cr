require "../../../spec_helper"

describe Bill::Transactions::Update do
  it "updates transaction" do
    new_description = "Another transaction"

    user = UserFactory.create

    transaction = TransactionFactory.create &.user_id(user.id)
      .description("New transaction")

    response = ApiClient.exec(
      Transactions::Update.with(transaction_id: transaction.id),
      transaction: {description: new_description}
    )

    transaction.reload.description.should eq(new_description)
    response.status.should eq(HTTP::Status::FOUND)
  end
end
