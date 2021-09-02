require "../../spec_helper"

describe Bill::UpdateInvoiceItem do
  it "updates existing invoice item" do
    new_description = "Another invoice item"
    new_quantity = 2

    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)

    invoice_item = InvoiceItemFactory.create &.invoice_id(invoice.id)
      .description("New invoice item")
      .quantity(1)
      .price(222)

    UpdateInvoiceItem.update(
      InvoiceItemQuery.preload_invoice(invoice_item),
      params(
        description: new_description,
        quantity: new_quantity,
        price_mu: 3.33
      )
    ) do |operation, updated_invoice_item|
      operation.saved?.should be_true

      updated_invoice_item.description.should eq(new_description)
      updated_invoice_item.quantity.should eq(new_quantity)
      updated_invoice_item.price.should eq(333)
    end
  end
end
