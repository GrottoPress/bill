require "../../../spec_helper"

private class SaveInvoice < Invoice::SaveOperation
  permit_columns :user_id, :description, :due_at, :status

  include Bill::ValidateInvoice
end

describe Bill::ValidateInvoice do
  it "requires user id" do
    SaveInvoice.create(params(
      description: "New invoice",
      due_at: 1.day.from_now,
      status: :open
    )) do |operation, invoice|
      invoice.should be_nil

      assert_invalid(operation.user_id, " required")
    end
  end

  it "requires description" do
    SaveInvoice.create(params(
      user_id: UserFactory.create.id,
      due_at: 1.day.from_now,
      status: :open
    )) do |operation, invoice|
      invoice.should be_nil

      assert_invalid(operation.description, " required")
    end
  end

  it "requires due date" do
    SaveInvoice.create(params(
      user_id: UserFactory.create.id,
      status: :open
    )) do |operation, invoice|
      invoice.should be_nil

      assert_invalid(operation.due_at, " required")
    end
  end

  it "requires status" do
    SaveInvoice.create(params(
      user_id: UserFactory.create.id,
      description: "New invoice"
    )) do |operation, invoice|
      invoice.should be_nil

      assert_invalid(operation.status, " required")
    end
  end

  it "requires existing user" do
    SaveInvoice.create(params(
      user_id: 2_i64,
      description: "New invoice",
      due_at: 1.day.from_now,
      status: :open
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
