require "../../spec_helper"

describe Bill::UpdateFinalizedCreditNote do
  it "updates finalized credit note" do
    new_description = "Another credit note"

    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
      .status(:open)

    CreditNoteItemFactory.create &.credit_note_id(credit_note.id)

    UpdateFinalizedCreditNote.update(
      CreditNoteQuery.preload_line_items(credit_note),
      params(description: new_description),
      line_items: Array(Hash(String, String)).new
    ) do |operation, updated_credit_note|
      operation.saved?.should be_true
      updated_credit_note.description.should eq(new_description)
    end
  end

  it "requires finalized credit note" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)

    CreditNoteItemFactory.create &.credit_note_id(credit_note.id)

    UpdateFinalizedCreditNote.update(
      CreditNoteQuery.preload_line_items(credit_note),
      params(description: "Another credit note"),
      line_items: Array(Hash(String, String)).new
    ) do |operation, _|
      operation.saved?.should be_false

      operation.status
        .should have_error("operation.error.credit_note_not_finalized")
    end
  end
end
