require "../../../spec_helper"

describe Bill::Transactions::Show do
  it "shows transaction" do
    user = UserFactory.create
    transaction = TransactionFactory.create &.user_id(user.id)

    response = ApiClient.exec(Transactions::Show.with(
      transaction_id: transaction.id
    ))

    response.body.should eq("Transactions::ShowPage")
  end
end
