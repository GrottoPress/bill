require "../../../spec_helper"

describe Bill::DirectReceipts::Edit do
  it "renders edit page" do
    user = UserFactory.create
    transaction = TransactionFactory.create &.user_id(user.id)

    response = ApiClient.exec(DirectReceipts::Edit.with(
      transaction_id: transaction.id
    ))

    response.body.should eq("DirectReceipts::EditPage")
  end
end
