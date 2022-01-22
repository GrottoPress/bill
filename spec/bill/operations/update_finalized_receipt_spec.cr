require "../../spec_helper"

describe Bill::UpdateFinalizedReceipt do
  it "updates finalized receipt" do
    new_description = "Another receipt"

    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id).status(:open).amount(9)

    UpdateFinalizedReceipt.update(
      receipt,
      params(description: new_description, amount: 40)
    ) do |operation, updated_receipt|
      operation.saved?.should be_true
      updated_receipt.description.should eq(new_description)
      updated_receipt.amount.should eq(9)
    end
  end

  it "requires finalized receipt" do
    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id).amount(9)

    UpdateFinalizedReceipt.update(
      receipt,
      params(description: "Another receipt")
    ) do |operation, updated_receipt|
      operation.saved?.should be_false

      operation.status
        .should_not be_valid("operation.error.receipt_not_finalized")
    end
  end
end
