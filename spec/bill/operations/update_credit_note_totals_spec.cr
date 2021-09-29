require "../../spec_helper"

describe Bill::UpdateCreditNoteTotals do
  it "updates credit note totals" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
    CreditNoteItemFactory.create &.credit_note_id(credit_note.id).price(9)
    CreditNoteItemFactory.create &.credit_note_id(credit_note.id).price(6)

    UpdateCreditNoteTotals.update(
      credit_note
    ) do |operation, updated_credit_note|
      operation.saved?.should be_true
      updated_credit_note.totals.should be_a(CreditNoteTotals)

      updated_credit_note.totals.try do |totals|
        totals.line_items.should eq(9 + 6)
      end
    end
  end
end
