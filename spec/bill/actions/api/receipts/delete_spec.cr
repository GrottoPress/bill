require "../../../../spec_helper"

describe Bill::Api::Receipts::Delete do
  it "deletes receipt" do
    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id)

    response = ApiClient.exec(Api::Receipts::Delete.with(
      receipt_id: receipt.id
    ))

    # ameba:disable Performance/AnyInsteadOfEmpty
    ReceiptQuery.new.id(receipt.id).any?.should be_false

    response.should send_json(200, message: "action.receipt.destroy.success")
  end
end
