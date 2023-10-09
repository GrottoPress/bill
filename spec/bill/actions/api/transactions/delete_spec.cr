require "../../../../spec_helper"

describe Bill::Api::Transactions::Delete do
  it "deletes transaction" do
    user = UserFactory.create
    transaction = TransactionFactory.create &.user_id(user.id)

    response = ApiClient.exec(Api::Transactions::Delete.with(
      transaction_id: transaction.id
    ))

    # ameba:disable Performance/AnyInsteadOfEmpty
    TransactionQuery.new.id(transaction.id).any?.should be_false

    response.should send_json(
      200,
      message: "action.transaction.destroy.success"
    )
  end
end
