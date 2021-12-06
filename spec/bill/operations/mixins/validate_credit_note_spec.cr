require "../../../spec_helper"

private class SaveCreditNote < CreditNote::SaveOperation
  permit_columns :invoice_id, :description, :status

  include Bill::ValidateCreditNote
end

describe Bill::ValidateCreditNote do
  it "requires invoice id" do
    SaveCreditNote.create(params(
      description: "New credit note",
      status: :open
    )) do |operation, credit_note|
      credit_note.should be_nil

      assert_invalid(
        operation.invoice_id,
        "operation.error.invoice_id_required"
      )
    end
  end

  it "requires description" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

    SaveCreditNote.create(params(
      invoice_id: invoice.id,
      status: :open
    )) do |operation, credit_note|
      credit_note.should be_nil

      assert_invalid(
        operation.description,
        "operation.error.description_required"
      )
    end
  end

  it "requires status" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

    SaveCreditNote.create(params(
      invoice_id: invoice.id,
      description: "New credit note"
    )) do |operation, credit_note|
      credit_note.should be_nil

      assert_invalid(operation.status, "operation.error.status_required")
    end
  end

  it "requires existing invoice" do
    SaveCreditNote.create(params(
      invoice_id: 2_i64,
      description: "New credit note",
      status: :open
    )) do |operation, credit_note|
      credit_note.should be_nil

      assert_invalid(operation.invoice_id, "operation.error.invoice_not_found")
    end
  end

  it "requires finalized invoice" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:draft)

    SaveCreditNote.create(params(
      invoice_id: invoice.id,
      description: "New credit note",
      status: :draft
    )) do |operation, credit_note|
      credit_note.should be_nil

      assert_invalid(
        operation.invoice_id,
        "operation.error.invoice_not_finalized"
      )
    end
  end

  it "rejects invalid transition" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
      .status(:open)

    SaveCreditNote.update(
      credit_note,
      params(status: :draft)
    ) do |operation, updated_credit_note|
      operation.saved?.should be_false

      assert_invalid(
        operation.status,
        "operation.error.status_transition_invalid"
      )
    end
  end
end
