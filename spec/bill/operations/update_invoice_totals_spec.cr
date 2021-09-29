require "../../spec_helper"

describe Bill::UpdateInvoiceTotals do
  it "updates invoice totals" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    InvoiceItemFactory.create &.invoice_id(invoice.id).price(9)
    InvoiceItemFactory.create &.invoice_id(invoice.id).price(6)

    UpdateInvoiceTotals.update(invoice) do |operation, updated_invoice|
      operation.saved?.should be_true
      updated_invoice.totals.should be_a(InvoiceTotals)

      updated_invoice.totals.try do |totals|
        totals.line_items.should eq(9 + 6)
      end
    end
  end
end
