require "../../../spec_helper"

private class SaveReceipt < Receipt::SaveOperation
  permit_columns :user_id,
    :amount,
    :business_details,
    :description,
    :reference,
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

      operation.user_id.should have_error("operation.error.user_id_required")
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

      operation.description
        .should have_error("operation.error.description_required")
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

      operation.amount.should have_error("operation.error.amount_required")
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

      operation.amount.should have_error("operation.error.amount_lte_zero")
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

      operation.status.should have_error("operation.error.status_required")
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

      operation.business_details
        .should have_error("operation.error.business_details_required")
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

      operation.user_details
        .should have_error("operation.error.user_details_required")
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

      operation.user_id.should have_error("operation.error.user_not_found")
    end
  end

  it "rejects invalid transition" do
    user = UserFactory.create
    receipt = ReceiptFactory.create &.user_id(user.id).status(:open)

    SaveReceipt.update(
      receipt,
      params(status: :draft)
    ) do |operation, _|
      operation.saved?.should be_false

      operation.status
        .should have_error("operation.error.status_transition_invalid")
    end
  end

  it "ensures reference is unique" do
    reference = "123"

    user = UserFactory.create
    ReceiptFactory.create &.user_id(user.id).reference(reference)

    SaveReceipt.create(params(
      user_id: user.id,
      business_details: "ACME Inc",
      description: "New receipt",
      amount: 90,
      reference: reference,
      status: :open,
      user_details: "Mary Smith"
    )) do |operation, receipt|
      receipt.should be_nil

      operation.reference.should have_error("operation.error.reference_exists")
    end
  end
end
