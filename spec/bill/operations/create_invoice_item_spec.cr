require "../../spec_helper"

describe Bill::CreateInvoiceItem do
  it "creates new invoice item" do
    description = "New invoice item"
    quantity = 2

    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)

    CreateInvoiceItem.create(params(
      invoice_id: invoice.id,
      description: description,
      quantity: quantity,
      price_mu: 3.33
    )) do |_, invoice_item|
      invoice_item.should be_a(InvoiceItem)

      invoice_item.try do |invoice_item|
        invoice_item.invoice_id.should eq(invoice.id)
        invoice_item.description.should eq(description)
        invoice_item.quantity.should eq(quantity)
        invoice_item.price.should eq(333)
      end
    end
  end
end
