require "../../../spec_helper"

private class SaveReceipt < Receipt::SaveOperation
  permit_columns :user_id, :amount, :description, :status

  include Bill::ValidateReceipt
end

describe Bill::ValidateReceipt do
  it "requires user id" do
    SaveReceipt.create(params(
      description: "New receipt",
      amount: 90,
      status: :open
    )) do |operation, receipt|
      receipt.should be_nil

      assert_invalid(operation.user_id, " required")
    end
  end

  it "requires description" do
    SaveReceipt.create(params(
      user_id: UserFactory.create.id,
      amount: 90,
      status: :open
    )) do |operation, receipt|
      receipt.should be_nil

      assert_invalid(operation.description, " required")
    end
  end

  it "requires amount" do
    SaveReceipt.create(params(
      user_id: UserFactory.create.id,
      description: "New receipt",
      status: :open
    )) do |operation, receipt|
      receipt.should be_nil

      assert_invalid(operation.amount, " required")
    end
  end

  it "ensures amount is greater than zero" do
    SaveReceipt.create(params(
      user_id: UserFactory.create.id,
      description: "New receipt",
      amount: 0,
      status: :open,
    )) do |operation, receipt|
      receipt.should be_nil

      assert_invalid(operation.amount, "greater than")
    end
  end

  it "requires status" do
    SaveReceipt.create(params(
      user_id: UserFactory.create.id,
      description: "New receipt",
      amount: 90
    )) do |operation, receipt|
      receipt.should be_nil

      assert_invalid(operation.status, " required")
    end
  end

  it "requires existing user" do
    SaveReceipt.create(params(
      user_id: 2_i64,
      description: "New receipt",
      amount: 90,
      status: :open
    )) do |operation, receipt|
      receipt.should be_nil

      assert_invalid(operation.user_id, "not exist")
    end
  end

  it "rejects invalid transition" do
    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id).status(:open)

    SaveReceipt.update(
      receipt,
      params(status: :draft)
    ) do |operation, updated_receipt|
      operation.saved?.should be_false

      assert_invalid(operation.status, "change")
    end
  end
end
