require "../../../spec_helper"

describe Bill::ReceiptsStatus::Edit do
  it "edits receipt status" do
    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id)

    response = ApiClient.exec(ReceiptsStatus::Edit.with(receipt_id: receipt.id))

    response.body.should eq("ReceiptsStatus::EditPage")
  end
end
