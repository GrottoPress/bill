require "../../../spec_helper"

describe Bill::CreditTransactions::Create do
  it "creates transaction" do
    response = ApiClient.exec(
      CreditTransactions::Create,
      transaction: {
        user_id: UserFactory.create.id,
        description: "New transaction",
        type: :invoice,
        amount: 3
      }
    )

    # ameba:disable Performance/AnyInsteadOfEmpty
    TransactionQuery.new.any?.should be_true

    response.status.should eq(HTTP::Status::FOUND)
  end
end
