require "../../spec_helper"

describe Bill::UpdateCreditNoteStatus do
  it "updates credit note status" do
    new_status = CreditNoteStatus.new(:open)

    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
      .status(:draft)

    CreditNoteItemFactory.create &.credit_note_id(credit_note.id)

    UpdateCreditNoteStatus.update(
      CreditNoteQuery.preload_line_items(credit_note),
      params(status: new_status)
    ) do |operation, updated_credit_note|
      operation.saved?.should be_true
      updated_credit_note.status.should eq(new_status)
    end
  end
end
