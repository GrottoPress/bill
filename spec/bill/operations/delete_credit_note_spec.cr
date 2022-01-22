require "../../spec_helper"

describe Bill::DeleteCreditNote do
  it "deletes credit note" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)

    DeleteCreditNote.delete(credit_note) do |operation, _|
      operation.deleted?.should be_true
    end

    CreditNoteQuery.new.id(credit_note.id).any?.should be_false
  end

  it "prevents deleting finalized credit note" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
      .status(:open)

    DeleteCreditNote.delete(credit_note) do |operation, _|
      operation.deleted?.should be_false

      operation.status
        .should have_error("operation.error.credit_note_finalized")
    end
  end
end
