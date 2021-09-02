require "../../../spec_helper"

describe Bill::HasManyInvoiceItems do
  describe "#line_items_amount!" do
    it "returns the correct amount" do
      description = "New invoice"
      due_at = 3.days.from_now.to_utc
      notes = "A note"

      user = UserFactory.create
      invoice = InvoiceFactory.create &.user_id(user.id)

      InvoiceItemFactory.create &.invoice_id(invoice.id).quantity(3).price(14)
      InvoiceItemFactory.create &.invoice_id(invoice.id).quantity(2).price(15)

      user_2 = UserFactory.create &.email("aa@bb.cc")
      invoice_2 = InvoiceFactory.create &.user_id(user_2.id)

      InvoiceItemFactory.create &.invoice_id(invoice_2.id).quantity(5).price(12)
      InvoiceItemFactory.create &.invoice_id(invoice_2.id).quantity(7).price(10)

      invoice.line_items_amount!.should eq(3 * 14 + 2 * 15)
      invoice_2.line_items_amount!.should eq(5 * 12 + 7 * 10)
    end
  end
end
