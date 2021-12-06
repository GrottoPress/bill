require "../../../spec_helper"

private class SaveReceipt < Receipt::SaveOperation
  permit_columns :user_id,
    :amount,
    :business_details,
    :description,
    :status,
    :user_details

  include Bill::ValidateReceipt
end

describe Bill::ValidateReceipt do
  it "requires user id" do
    SaveReceipt.create(params(
      business_details: "ACME Inc",
      description: "New receipt",
      amount: 90,
      status: :open,
      user_details: "Mary Smith"
    )) do |operation, receipt|
      receipt.should be_nil

      assert_invalid(operation.user_id, "operation.error.user_id_required")
    end
  end

  it "requires description" do
    SaveReceipt.create(params(
      user_id: UserFactory.create.id,
      business_details: "ACME Inc",
      amount: 90,
      status: :open,
      user_details: "Mary Smith"
    )) do |operation, receipt|
      receipt.should be_nil

      assert_invalid(
        operation.description,
        "operation.error.description_required"
      )
    end
  end

  it "requires amount" do
    SaveReceipt.create(params(
      user_id: UserFactory.create.id,
      business_details: "ACME Inc",
      description: "New receipt",
      status: :open,
      user_details: "Mary Smith"
    )) do |operation, receipt|
      receipt.should be_nil

      assert_invalid(operation.amount, "operation.error.amount_required")
    end
  end

  it "ensures amount is greater than zero" do
    SaveReceipt.create(params(
      user_id: UserFactory.create.id,
      business_details: "ACME Inc",
      description: "New receipt",
      amount: 0,
      status: :open,
      user_details: "Mary Smith"
    )) do |operation, receipt|
      receipt.should be_nil

      assert_invalid(operation.amount, "operation.error.amount_lte_zero")
    end
  end

  it "requires status" do
    SaveReceipt.create(params(
      user_id: UserFactory.create.id,
      business_details: "ACME Inc",
      description: "New receipt",
      amount: 90,
      user_details: "Mary Smith"
    )) do |operation, receipt|
      receipt.should be_nil

      assert_invalid(operation.status, "operation.error.status_required")
    end
  end

  it "requires business details" do
    SaveReceipt.create(params(
      user_id: UserFactory.create.id,
      description: "New receipt",
      amount: 90,
      status: :open,
      user_details: "Mary Smith"
    )) do |operation, receipt|
      receipt.should be_nil

      assert_invalid(
        operation.business_details,
        "operation.error.business_details_required"
      )
    end
  end

  it "requires user details" do
    SaveReceipt.create(params(
      user_id: UserFactory.create.id,
      business_details: "ACME Inc",
      description: "New receipt",
      amount: 90,
      status: :draft
    )) do |operation, receipt|
      receipt.should be_nil

      assert_invalid(
        operation.user_details,
        "operation.error.user_details_required"
      )
    end
  end

  it "requires existing user" do
    SaveReceipt.create(params(
      user_id: 2_i64,
      business_details: "ACME Inc",
      description: "New receipt",
      amount: 90,
      status: :open,
      user_details: "Mary Smith"
    )) do |operation, receipt|
      receipt.should be_nil

      assert_invalid(operation.user_id, "operation.error.user_not_found")
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

      assert_invalid(
        operation.status,
        "operation.error.status_transition_invalid"
      )
    end
  end
end
