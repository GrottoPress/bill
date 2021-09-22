require "../../../spec_helper"

describe Bill::Receipts::Delete do
  it "deletes receipt" do
    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id)

    response = ApiClient.exec(Receipts::Delete.with(receipt_id: receipt.id))

    ReceiptQuery.new.id(receipt.id).any?.should be_false
    response.status.should eq(HTTP::Status::FOUND)
  end
end
