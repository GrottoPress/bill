require "../../../../spec_helper"

describe Bill::Api::DebitTransactions::Create do
  it "creates transaction" do
    response = ApiClient.exec(
      Api::DebitTransactions::Create,
      transaction: {
        user_id: UserFactory.create.id,
        description: "New transaction",
        type: :invoice,
        amount: 4
      }
    )

    TransactionQuery.new.any?.should be_true

    response.should send_json(
      200,
      data: {transaction: {type: "TransactionSerializer"}}
    )
  end
end
