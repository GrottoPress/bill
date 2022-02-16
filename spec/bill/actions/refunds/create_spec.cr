require "../../../spec_helper"

describe Bill::Refunds::Create do
  it "creates refund transaction" do
    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id).amount(20).status(:open)

    response = ApiClient.exec(
      Refunds::Create.with(receipt_id: receipt.id),
      transaction: {amount: 10}
    )

    # ameba:disable Performance/AnyInsteadOfEmpty
    TransactionQuery.new.any?.should be_true
    response.status.should eq(HTTP::Status::FOUND)
  end
end
