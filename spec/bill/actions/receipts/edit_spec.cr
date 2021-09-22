require "../../../spec_helper"

describe Bill::Receipts::Edit do
  it "edits receipt" do
    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id)

    response = ApiClient.exec(Receipts::Edit.with(receipt_id: receipt.id))

    response.body.should eq("Receipts::EditPage")
  end
end
