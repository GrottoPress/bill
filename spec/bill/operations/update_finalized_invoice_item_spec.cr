require "../../spec_helper"

describe Bill::UpdateFinalizedInvoiceItem do
  it "updates item for finalized invoice" do
    new_description = "Another invoice item"

    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

    invoice_item = InvoiceItemFactory.create &.invoice_id(invoice.id)
      .description("New invoice item")
      .quantity(1)
      .price(222)

    UpdateFinalizedInvoiceItem.update(
      InvoiceItemQuery.preload_invoice(invoice_item),
      params(
        description: new_description,
        quantity: 2,
        price_mu: 3.33
      )
    ) do |operation, updated_invoice_item|
      operation.saved?.should be_true

      updated_invoice_item.description.should eq(new_description)
      updated_invoice_item.quantity.should eq(1)
      updated_invoice_item.price.should eq(222)
    end
  end
end
