require "../../../spec_helper"

describe Bill::ReceiptsStatus::Update do
  it "updates receipt status" do
    new_status = ReceiptStatus.new(:open)

    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id).status(:draft)

    response = ApiClient.exec(
      ReceiptsStatus::Update.with(receipt_id: receipt.id),
      receipt: {status: new_status}
    )

    receipt.reload.status.should eq(new_status)
    response.status.should eq(HTTP::Status::FOUND)
  end
end
