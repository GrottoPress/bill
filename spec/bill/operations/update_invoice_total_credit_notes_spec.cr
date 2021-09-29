require "../../spec_helper"

describe Bill::UpdateInvoiceTotalCreditNotes do
  it "updates credit notes total for invoice" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)

    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
      .status(:open)

    CreditNoteItemFactory.create &.credit_note_id(credit_note.id).price(9)
    CreditNoteItemFactory.create &.credit_note_id(credit_note.id).price(6)

    UpdateInvoiceTotalCreditNotes.update(
      invoice
    ) do |operation, updated_invoice|
      operation.saved?.should be_true
      updated_invoice.totals.should be_a(InvoiceTotals)

      updated_invoice.totals.try do |totals|
        totals.credit_notes.should eq(9 + 6)
      end
    end
  end
end
