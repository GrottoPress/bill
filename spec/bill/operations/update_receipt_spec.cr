require "../../spec_helper"

describe Bill::UpdateReceipt do
  it "updates existing receipt" do
    user = UserFactory.create

    receipt = ReceiptFactory.create &.user_id(user.id)
      .counter(1401)
      .amount(21)
      .description("New receipt")
      .notes("A note")
      .status(:draft)

    new_user = UserFactory.create &.email("some@one.now")
    new_description = "Another receipt"
    new_amount = 45
    new_notes = "Another note"
    new_status = ReceiptStatus.new(:open)

    TransactionQuery.new.none?.should be_true

    UpdateReceipt.update(receipt, params(
      user_id: new_user.id,
      description: new_description,
      amount: new_amount,
      notes: new_notes,
      status: new_status
    )) do |operation, updated_receipt|
      operation.saved?.should be_true

      updated_receipt.user_id.should eq(new_user.id)
      updated_receipt.description.should eq(new_description)
      updated_receipt.amount.should eq(new_amount)
      updated_receipt.notes.should eq(new_notes)
      updated_receipt.reference.should eq("RCT1401")
      updated_receipt.status.should eq(new_status)
    end

    TransactionQuery.new
      .user_id(new_user.id)
      .type(:receipt)
      .is_finalized
      .none?
      .should(be_false)
  end

  it "prevents modifying finalized receipt" do
    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id).status(:open)

    UpdateReceipt.update(
      receipt,
      params(description: "Another receipt")
    ) do |operation, _|
      operation.saved?.should be_false

      operation.status.should have_error("operation.error.receipt_finalized")
    end
  end
end
