require "../../../spec_helper"

describe Bill::DebitTransactions::Create do
  it "creates transaction" do
    response = ApiClient.exec(
      DebitTransactions::Create,
      transaction: {
        user_id: UserFactory.create.id,
        description: "New transaction",
        type: :invoice,
        amount: 4
      }
    )

    TransactionQuery.new.any?.should be_true
    response.status.should eq(HTTP::Status::FOUND)
  end
end
