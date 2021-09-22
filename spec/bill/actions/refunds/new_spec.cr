require "../../../spec_helper"

describe Bill::Refunds::New do
  it "renders new page" do
    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id)

    response = ApiClient.exec(Refunds::New.with(receipt_id: receipt.id))

    response.body.should eq("Refunds::NewPage")
  end
end
