require "../../../spec_helper"

private class SaveInvoice < Invoice::SaveOperation
  permit_columns :user_id,
    :business_details,
    :description,
    :due_at,
    :status,
    :user_details

  include Bill::ValidateInvoice
end

describe Bill::ValidateInvoice do
  it "requires user id" do
    SaveInvoice.create(params(
      business_details: "ACME Inc",
      description: "New invoice",
      due_at: 1.day.from_now,
      status: :open,
      user_details: "Mary Smith"
    )) do |operation, invoice|
      invoice.should be_nil

      operation.user_id.should_not be_valid("operation.error.user_id_required")
    end
  end

  it "requires description" do
    SaveInvoice.create(params(
      user_id: UserFactory.create.id,
      business_details: "ACME Inc",
      due_at: 1.day.from_now,
      status: :open,
      user_details: "Mary Smith"
    )) do |operation, invoice|
      invoice.should be_nil

      operation.description
        .should_not be_valid("operation.error.description_required")
    end
  end

  it "requires due date" do
    SaveInvoice.create(params(
      user_id: UserFactory.create.id,
      business_details: "ACME Inc",
      status: :open,
      user_details: "Mary Smith"
    )) do |operation, invoice|
      invoice.should be_nil

      operation.due_at.should_not be_valid("operation.error.due_at_required")
    end
  end

  it "requires status" do
    SaveInvoice.create(params(
      user_id: UserFactory.create.id,
      business_details: "ACME Inc",
      description: "New invoice",
      user_details: "Mary Smith"
    )) do |operation, invoice|
      invoice.should be_nil

      operation.status.should_not be_valid("operation.error.status_required")
    end
  end

  it "requires business details" do
    SaveInvoice.create(params(
      user_id: UserFactory.create.id,
      description: "New invoice",
      status: :open,
      user_details: "Mary Smith"
    )) do |operation, invoice|
      invoice.should be_nil

      operation.business_details
        .should_not be_valid("operation.error.business_details_required")
    end
  end

  it "requires user details" do
    SaveInvoice.create(params(
      user_id: UserFactory.create.id,
      business_details: "ACME Inc",
      description: "New invoice",
      status: :draft
    )) do |operation, invoice|
      invoice.should be_nil

      operation.user_details
        .should_not be_valid("operation.error.user_details_required")
    end
  end

  it "requires existing user" do
    SaveInvoice.create(params(
      user_id: 2_i64,
      business_details: "ACME Inc",
      description: "New invoice",
      due_at: 1.day.from_now,
      status: :open,
      user_details: "Mary Smith"
    )) do |operation, invoice|
      invoice.should be_nil

      operation.user_id.should_not be_valid("operation.error.user_not_found")
    end
  end

  it "rejects invalid transition" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

    SaveInvoice.update(
      invoice,
      params(status: :draft)
    ) do |operation, updated_invoice|
      operation.saved?.should be_false

      operation.status
        .should_not be_valid("operation.error.status_transition_invalid")
    end
  end
end
