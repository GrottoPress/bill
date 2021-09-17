require "../../../spec_helper"

private class SaveCreditNote < CreditNote::SaveOperation
  permit_columns :invoice_id, :description, :status

  include Bill::SendFinalizedCreditNoteEmail
end

describe Bill::SendFinalizedCreditNoteEmail do
  it "sends email for new credit notes" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

    SaveCreditNote.create(params(
      invoice_id: invoice.id,
      description: "New credit note",
      status: :open
    )) do |operation, credit_note|
      credit_note.should be_a(CreditNote)

      credit_note.try do |credit_note|
        credit_note = CreditNoteQuery.preload_invoice(
          credit_note,
          InvoiceQuery.new.preload_user
        )

        NewCreditNoteEmail.new(operation, credit_note).should be_delivered
      end
    end
  end

  it "sends email for existing credit notes" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)

    SaveCreditNote.update(credit_note, params(
      description: "New credit note",
      status: :open
    )) do |operation, updated_credit_note|
      operation.saved?.should be_true

      updated_credit_note = CreditNoteQuery.preload_invoice(
        updated_credit_note,
        InvoiceQuery.new.preload_user
      )

      NewCreditNoteEmail.new(operation, updated_credit_note).should be_delivered
    end
  end

  it "does not send email for unfinalized credit notes" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
      .status(:draft)

    SaveCreditNote.update(credit_note, params(
      description: "Another credit note",
    )) do |operation, updated_credit_note|
      operation.saved?.should be_true

      updated_credit_note = CreditNoteQuery.preload_invoice(
        updated_credit_note,
        InvoiceQuery.new.preload_user
      )

      NewCreditNoteEmail.new(operation, updated_credit_note)
        .should_not(be_delivered)
    end
  end

  it "does not send email for already finalized credit notes" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
      .status(:open)

    SaveCreditNote.update(credit_note, params(
      description: "Another credit note",
    )) do |operation, updated_credit_note|
      operation.saved?.should be_true

      updated_credit_note = CreditNoteQuery.preload_invoice(
        updated_credit_note,
        InvoiceQuery.new.preload_user
      )

      NewCreditNoteEmail.new(operation, updated_credit_note)
        .should_not(be_delivered)
    end
  end
end
