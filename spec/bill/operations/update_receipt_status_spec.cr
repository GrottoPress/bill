require "../../spec_helper"

describe Bill::UpdateReceiptStatus do
  it "updates receipt status" do
    new_status = ReceiptStatus.new(:open)

    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id).status(:draft)

    UpdateReceiptStatus.update(
      receipt,
      params(status: new_status)
    ) do |operation, updated_receipt|
      operation.saved?.should be_true
      updated_receipt.status.should eq(new_status)
    end
  end
end
