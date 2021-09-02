require "../../../spec_helper"

private class SaveInvoiceItem < InvoiceItem::SaveOperation
  permit_columns :invoice_id, :description, :quantity, :price

  include Bill::ValidateInvoiceItem
end

describe Bill::ValidateInvoiceItem do
  it "requires invoice id" do
    SaveInvoiceItem.create(params(
      description: "New invoice item",
      price: 222
    )) do |operation, invoice_item|
      invoice_item.should be_nil

      assert_invalid(operation.invoice_id, " required")
    end
  end

  it "requires existing invoice" do
    SaveInvoiceItem.create(params(
      invoice_id: 1_i64,
      description: "New invoice item",
      price: 222
    )) do |operation, invoice_item|
      invoice_item.should be_nil

      assert_invalid(operation.invoice_id, "not exist")
    end
  end

  it "requires description" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)

    SaveInvoiceItem.create(params(
      invoice_id: invoice.id,
      price: 222
    )) do |operation, invoice_item|
      invoice_item.should be_nil

      assert_invalid(operation.description, " required")
    end
  end

  it "requires price" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)

    SaveInvoiceItem.create(params(
      invoice_id: invoice.id,
      description: "New invoice item"
    )) do |operation, invoice_item|
      invoice_item.should be_nil

      assert_invalid(operation.price, " required")
    end
  end

  it "requires price to be greater than 0" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)

    SaveInvoiceItem.create(params(
      invoice_id: invoice.id,
      description: "New invoice item",
      price: 0
    )) do |operation, invoice_item|
      invoice_item.should be_nil

      assert_invalid(operation.price, "greater than")
    end
  end

  it "requires quantity to be greater than 0" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)

    SaveInvoiceItem.create(params(
      invoice_id: invoice.id,
      description: "New invoice item",
      quantity: 0,
      price: 222
    )) do |operation, invoice_item|
      invoice_item.should be_nil

      assert_invalid(operation.quantity, "greater than")
    end
  end

  it "ensures invoice is not finalized" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:paid)
    invoice_item = InvoiceItemFactory.create &.invoice_id(invoice.id)

    SaveInvoiceItem.update(
      InvoiceItemQuery.preload_invoice(invoice_item),
      params(description: "New invoice item")
    ) do |operation, _|
      operation.saved?.should be_false

      assert_invalid(operation.invoice_id, "finalized")
    end
  end
end
