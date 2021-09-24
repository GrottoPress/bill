require "../../../spec_helper"

private class SpecCreateReceipt < Receipt::SaveOperation
  permit_columns :user_id,
    :amount,
    :business_details,
    :description,
    :status,
    :user_details

  include Bill::CreateFinalizedReceiptTransaction
end

private class SpecUpdateReceipt < Receipt::SaveOperation
  permit_columns :user_id,
    :amount,
    :business_details,
    :description,
    :status,
    :user_details

  include Bill::CreateFinalizedReceiptTransaction
end

describe Bill::CreateFinalizedReceiptTransaction do
  it "creates transaction for new receipt" do
    user = UserFactory.create

    SpecCreateReceipt.create(params(
      user_id: user.id,
      business_details: "ACME Inc",
      description: "New receipt",
      amount: 65,
      status: :open,
      user_details: "Mary Smith",
    )) do |_, receipt|
      receipt.should be_a(Receipt)
    end

    TransactionQuery.new.user_id(user.id).any?.should be_true
  end

  it "creates transaction for existing receipt" do
    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id).status(:draft)

    SpecUpdateReceipt.update(receipt, params(status: :open)) do |operation, _|
      operation.saved?.should be_true
    end

    TransactionQuery.new.user_id(user.id).any?.should be_true
  end

  it "does not create transaction for unfinalized receipts" do
    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id).status(:draft)

    SpecUpdateReceipt.update(receipt, params(
      description: "Another receipt",
    )) do |operation, updated_receipt|
      operation.saved?.should be_true
    end

    TransactionQuery.new.user_id(user.id).any?.should be_false
  end

  it "does not create transaction for already finalized receipts" do
    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id).status(:open)

    SpecUpdateReceipt.update(receipt, params(
      description: "Another receipt",
    )) do |operation, updated_receipt|
      operation.saved?.should be_true
    end

    TransactionQuery.new.user_id(user.id).any?.should be_false
  end
end
