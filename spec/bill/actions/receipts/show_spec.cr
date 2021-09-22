require "../../../spec_helper"

describe Bill::Receipts::Show do
  it "shows receipt" do
    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id)

    response = ApiClient.exec(Receipts::Show.with(receipt_id: receipt.id))

    response.body.should eq("Receipts::ShowPage")
  end
end
