require "../../../spec_helper"

describe Bill::Receipts::Create do
  it "creates receipt" do
    response = ApiClient.exec(Receipts::Create, receipt: {
      user_id: UserFactory.create.id,
      description: "New receipt",
      amount: 90
    })

    # ameba:disable Performance/AnyInsteadOfEmpty
    ReceiptQuery.new.any?.should be_true
    response.status.should eq(HTTP::Status::FOUND)
  end
end
