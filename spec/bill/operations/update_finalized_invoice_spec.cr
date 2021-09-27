require "../../spec_helper"

describe Bill::UpdateFinalizedInvoice do
  it "updates finalized invoice" do
    new_description = "Another invoice"

    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
    InvoiceItemFactory.create &.invoice_id(invoice.id)

    UpdateFinalizedInvoice.update(
      InvoiceQuery.preload_line_items(invoice),
      params(description: new_description),
      line_items: Array(Hash(String, String)).new
    ) do |operation, updated_invoice|
      operation.saved?.should be_true
      updated_invoice.description.should eq(new_description)
    end
  end
end
