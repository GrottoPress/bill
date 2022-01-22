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

      operation.invoice_id
        .should_not be_valid("operation.error.invoice_id_required")
    end
  end

  it "requires existing invoice" do
    SaveInvoiceItem.create(params(
      invoice_id: 1_i64,
      description: "New invoice item",
      price: 222
    )) do |operation, invoice_item|
      invoice_item.should be_nil

      operation.invoice_id
        .should_not be_valid("operation.error.invoice_not_found")
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

      operation.description
        .should_not be_valid("operation.error.description_required")
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

      operation.price.should_not be_valid("operation.error.price_required")
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

      operation.price.should_not be_valid("operation.error.price_lte_zero")
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

      operation.quantity
        .should_not be_valid("operation.error.quantity_lte_zero")
    end
  end
end
