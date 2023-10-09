require "../../../spec_helper"

describe Bill::Transactions::Delete do
  it "deletes transaction" do
    user = UserFactory.create
    transaction = TransactionFactory.create &.user_id(user.id)

    response = ApiClient.exec(Transactions::Delete.with(
      transaction_id: transaction.id
    ))

    # ameba:disable Performance/AnyInsteadOfEmpty
    TransactionQuery.new.id(transaction.id).any?.should be_false

    response.status.should eq(HTTP::Status::FOUND)
  end
end
