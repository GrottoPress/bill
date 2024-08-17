require "../../../spec_helper"

describe Bill::DirectReceipts::Create do
  it "creates direct receipt" do
    response = ApiClient.exec(DirectReceipts::Create, transaction: {
      user_id: UserFactory.create.id,
      description: "New receipt",
      amount: 90
    })

    # ameba:disable Performance/AnyInsteadOfEmpty
    TransactionQuery.new.any?.should be_true
    response.status.should eq(HTTP::Status::FOUND)
  end
end
