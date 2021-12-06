require "../../../../spec_helper"

describe Bill::Api::Refunds::Create do
  it "creates refund transaction" do
    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id).amount(20).status(:open)

    response = ApiClient.exec(
      Api::Refunds::Create.with(receipt_id: receipt.id),
      transaction: {amount: 10}
    )

    TransactionQuery.new.any?.should be_true

    response.should send_json(
      200,
      message: "action.refund.create.success"
    )
  end
end
