require "../../../spec_helper"

describe Bill::Transactions::Create do
  it "creates transaction" do
    response = ApiClient.exec(
      Transactions::Create,
      transaction: {
        user_id: UserFactory.create.id,
        description: "New transaction",
        type: :invoice,
        credit: false,
        amount: 3
      }
    )

    # ameba:disable Performance/AnyInsteadOfEmpty
    TransactionQuery.new.any?.should be_true

    response.status.should eq(HTTP::Status::FOUND)
  end
end
