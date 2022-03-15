require "../../../../spec_helper"

describe Bill::Api::Transactions::Show do
  it "shows transaction" do
    user = UserFactory.create
    transaction = TransactionFactory.create &.user_id(user.id)

    response = ApiClient.exec(Api::Transactions::Show.with(
      transaction_id: transaction.id
    ))

    response.should send_json(
      200,
      data: {transaction: {type: "Transaction"}}
    )
  end
end
