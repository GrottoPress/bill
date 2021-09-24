require "../../../spec_helper"

private class SaveReceipt < Receipt::SaveOperation
  permit_columns :user_id,
    :amount,
    :business_details,
    :description,
    :status,
    :user_details

  include Bill::SendFinalizedReceiptEmail
end

describe Bill::SendFinalizedReceiptEmail do
  it "sends email for new receipts" do
    SaveReceipt.create(params(
      user_id: UserFactory.create.id,
      business_details: "ACME Inc",
      description: "New receipt",
      amount: 29,
      status: :open,
      user_details: "Mary Smith"
    )) do |operation, receipt|
      receipt.should be_a(Receipt)

      receipt.try do |receipt|
        receipt = ReceiptQuery.preload_user(receipt)
        NewReceiptEmail.new(operation, receipt).should be_delivered
      end
    end
  end

  it "sends email for existing receipts" do
    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id).status(:draft)

    SaveReceipt.update(receipt, params(
      description: "Another receipt",
      status: :open
    )) do |operation, updated_receipt|
      operation.saved?.should be_true

      updated_receipt = ReceiptQuery.preload_user(updated_receipt)
      NewReceiptEmail.new(operation, updated_receipt).should be_delivered
    end
  end

  it "does not send email for unfinalized receipts" do
    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id).status(:draft)

    SaveReceipt.update(receipt, params(
      description: "Another receipt",
    )) do |operation, updated_receipt|
      operation.saved?.should be_true

      updated_receipt = ReceiptQuery.preload_user(updated_receipt)
      NewReceiptEmail.new(operation, updated_receipt).should_not(be_delivered)
    end
  end

  it "does not send email for already finalized receipts" do
    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id).status(:open)

    SaveReceipt.update(receipt, params(
      description: "Another receipt",
    )) do |operation, updated_receipt|
      operation.saved?.should be_true

      updated_receipt = ReceiptQuery.preload_user(updated_receipt)
      NewReceiptEmail.new(operation, updated_receipt).should_not(be_delivered)
    end
  end
end
