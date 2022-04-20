require "../../../spec_helper"

describe Bill::HasManyCreditNoteItems do
  describe "#line_items_amount!" do
    it "returns the correct amount" do
      user = UserFactory.create
      invoice = InvoiceFactory.create &.user_id(user.id)
      credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)

      CreditNoteItemFactory.create &.credit_note_id(credit_note.id)
        .quantity(3)
        .price(14)

      CreditNoteItemFactory.create &.credit_note_id(credit_note.id)
        .quantity(2)
        .price(15)

      user_2 = UserFactory.create &.email("aa@bb.cc")
      invoice_2 = InvoiceFactory.create &.user_id(user_2.id)
      credit_note_2 = CreditNoteFactory.create &.invoice_id(invoice_2.id)

      CreditNoteItemFactory.create &.credit_note_id(credit_note_2.id)
        .quantity(5)
        .price(12)

      CreditNoteItemFactory.create &.credit_note_id(credit_note_2.id)
        .quantity(7)
        .price(10)

      credit_note.line_items_amount!.should eq(3 * 14 + 2 * 15)
      credit_note_2.line_items_amount!.should eq(5 * 12 + 7 * 10)
    end
  end
end
