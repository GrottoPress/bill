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

      assert_invalid(operation.user_id, " required")
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

      assert_invalid(operation.description, " required")
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

      assert_invalid(operation.due_at, " required")
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

      assert_invalid(operation.status, " required")
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

      assert_invalid(operation.business_details, " required")
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

      assert_invalid(operation.user_details, " required")
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

      assert_invalid(operation.user_id, "not exist")
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

      assert_invalid(operation.status, "change")
    end
  end
end
