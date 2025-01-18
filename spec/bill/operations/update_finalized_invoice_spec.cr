require "../../spec_helper"

describe Bill::UpdateFinalizedInvoice do
  it "updates finalized invoice" do
    new_description = "Another invoice"

    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
    InvoiceItemFactory.create &.invoice_id(invoice.id)

    UpdateFinalizedInvoice.update(
      invoice,
      params(description: new_description),
      line_items: Array(Hash(String, String)).new
    ) do |operation, updated_invoice|
      operation.saved?.should be_true
      updated_invoice.description.should eq(new_description)
    end
  end

  it "requires finalized invoice" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:draft)
    InvoiceItemFactory.create &.invoice_id(invoice.id)

    UpdateFinalizedInvoice.update(
      invoice,
      params(description: "Another invoice"),
      line_items: Array(Hash(String, String)).new
    ) do |operation, _|
      operation.saved?.should be_false

      operation.status
        .should have_error("operation.error.invoice_not_finalized")
    end
  end
end
