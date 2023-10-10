require "../../../../spec_helper"

describe Bill::Api::Transactions::Create do
  it "creates transaction" do
    response = ApiClient.exec(
      Api::Transactions::Create,
      transaction: {
        user_id: UserFactory.create.id,
        description: "New transaction",
        credit: true,
        type: :invoice,
        amount: 3
      }
    )

    # ameba:disable Performance/AnyInsteadOfEmpty
    TransactionQuery.new.any?.should be_true

    response.should send_json(200, message: "action.transaction.create.success")
  end
end
