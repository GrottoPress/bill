require "../../../spec_helper"

private class SaveCreditNote < CreditNote::SaveOperation
  permit_columns :invoice_id, :description, :reference, :status

  include Bill::ValidateCreditNote
end

describe Bill::ValidateCreditNote do
  it "requires invoice id" do
    SaveCreditNote.create(params(
      description: "New credit note",
      status: :open
    )) do |operation, credit_note|
      credit_note.should be_nil

      operation.invoice_id
        .should have_error("operation.error.invoice_id_required")
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

      operation.status.should have_error("operation.error.status_required")
    end
  end

  it "requires existing invoice" do
    SaveCreditNote.create(params(
      invoice_id: 2_i64,
      description: "New credit note",
      status: :open
    )) do |operation, credit_note|
      credit_note.should be_nil

      operation.invoice_id
        .should have_error("operation.error.invoice_not_found")
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

      operation.invoice_id
        .should have_error("operation.error.invoice_not_finalized")
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
    ) do |operation, _|
      operation.saved?.should be_false

      operation.status
        .should have_error("operation.error.status_transition_invalid")
    end
  end

  it "ensures reference is unique" do
    reference = "123"

    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
    CreditNoteFactory.create &.invoice_id(invoice.id).reference(reference)

    SaveCreditNote.create(params(
      invoice_id: invoice.id,
      description: "New credit note",
      reference: reference,
      status: :open
    )) do |operation, credit_note|
      credit_note.should be_nil

      operation.reference.should have_error("operation.error.reference_exists")
    end
  end

  it "rejects long description" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

    SaveCreditNote.create(params(
      invoice_id: invoice.id,
      description: "d" * 600,
      reference: "123",
      status: :open
    )) do |operation, credit_note|
      credit_note.should be_nil

      operation.description
        .should(have_error "operation.error.description_too_long")
    end
  end
end
