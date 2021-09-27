require "../../../spec_helper"

describe Bill::FinalizedReceipts::Edit do
  it "edits finalized receipt" do
    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id).status(:open)

    response = ApiClient.exec(FinalizedReceipts::Edit.with(
      receipt_id: receipt.id
    ))

    response.body.should eq("FinalizedReceipts::EditPage")
  end
end
