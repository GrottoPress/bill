require "../../../../spec_helper"

describe Bill::Api::CreditTransactions::Create do
  it "creates transaction" do
    response = ApiClient.exec(
      Api::CreditTransactions::Create,
      transaction: {
        user_id: UserFactory.create.id,
        description: "New transaction",
        type: :invoice,
        amount: 3
      }
    )

    TransactionQuery.new.any?.should be_true
    response.should send_json(200, message: "action.transaction.create.success")
  end
end
