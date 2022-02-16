require "../../../../spec_helper"

describe Bill::Api::Receipts::Create do
  it "creates receipt" do
    response = ApiClient.exec(Api::Receipts::Create, receipt: {
      user_id: UserFactory.create.id,
      description: "New receipt",
      amount: 90
    })

    # ameba:disable Performance/AnyInsteadOfEmpty
    ReceiptQuery.new.any?.should be_true

    response.should send_json(200, message: "action.receipt.create.success")
  end
end
