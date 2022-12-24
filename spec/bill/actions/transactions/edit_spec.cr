require "../../../spec_helper"

describe Bill::Transactions::Edit do
  it "renders edit page" do
    user = UserFactory.create
    transaction = TransactionFactory.create &.user_id(user.id)

    response = ApiClient.exec(Transactions::Edit.with(
      transaction_id: transaction.id
    ))

    response.body.should eq("Transactions::EditPage")
  end
end
