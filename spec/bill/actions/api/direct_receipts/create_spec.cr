require "../../../../spec_helper"

describe Bill::Api::DirectReceipts::Create do
  it "creates direct receipt" do
    response = ApiClient.exec(Api::DirectReceipts::Create, transaction: {
      user_id: UserFactory.create.id,
      description: "New receipt",
      amount: 90
    })

    # ameba:disable Performance/AnyInsteadOfEmpty
    TransactionQuery.new.any?.should be_true
    response.should send_json(200, message: "action.receipt.create.success")
  end
end
