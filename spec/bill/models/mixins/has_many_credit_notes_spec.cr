require "../../../spec_helper"

describe Bill::HasManyCreditNotes do
  describe "#net_amount!" do
    it "returns the correct amount" do
      user = UserFactory.create
      invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

      InvoiceItemFactory.create &.invoice_id(invoice.id).quantity(3).price(14)
      InvoiceItemFactory.create &.invoice_id(invoice.id).quantity(2).price(15)

      credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
        .status(:open)

      CreditNoteItemFactory.create &.credit_note_id(credit_note.id)
        .quantity(2)
        .price(14)

      CreditNoteItemFactory.create &.credit_note_id(credit_note.id)
        .quantity(1)
        .price(15)

      invoice = InvoiceQuery.preload_line_items(invoice)
      invoice = InvoiceQuery.preload_credit_notes(invoice, CreditNoteQuery.new
        .preload_line_items)

      invoice.net_amount.should eq(3 * 14 + 2 * 15 - 2 * 14 - 1 * 15)
      invoice.net_amount!.should eq(3 * 14 + 2 * 15 - 2 * 14 - 1 * 15)
    end
  end

  describe "#credit_notes_amount!" do
    it "returns the correct amount" do
      user = UserFactory.create
      invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

      InvoiceItemFactory.create &.invoice_id(invoice.id).quantity(3).price(14)
      InvoiceItemFactory.create &.invoice_id(invoice.id).quantity(2).price(15)

      credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
        .status(:open)

      CreditNoteItemFactory.create &.credit_note_id(credit_note.id)
        .quantity(2)
        .price(14)

      CreditNoteItemFactory.create &.credit_note_id(credit_note.id)
        .quantity(1)
        .price(15)

      invoice = InvoiceQuery.preload_credit_notes(invoice, CreditNoteQuery.new
        .preload_line_items)

      invoice.credit_notes_amount.should eq(2 * 14 + 1 * 15)
      invoice.credit_notes_amount!.should eq(2 * 14 + 1 * 15)
    end
  end
end
