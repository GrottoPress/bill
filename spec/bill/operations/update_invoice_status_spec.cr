require "../../spec_helper"

describe Bill::UpdateInvoiceStatus do
  it "updates invoice status" do
    new_status = InvoiceStatus.new(:paid)

    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
    InvoiceItemFactory.create &.invoice_id(invoice.id)

    UpdateInvoiceStatus.update(
      InvoiceQuery.preload_line_items(invoice),
      params(status: new_status)
    ) do |operation, updated_invoice|
      operation.saved?.should be_true
      updated_invoice.status.should eq(new_status)
    end
  end
end
