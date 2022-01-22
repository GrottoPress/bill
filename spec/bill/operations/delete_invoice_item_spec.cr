require "../../spec_helper"

describe Bill::DeleteInvoiceItem do
  it "deletes invoice item" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    invoice_item = InvoiceItemFactory.create &.invoice_id(invoice.id)

    DeleteInvoiceItem.delete(
      InvoiceItemQuery.preload_invoice(invoice_item)
    ) do |operation, _|
      operation.deleted?.should be_true
    end

    InvoiceItemQuery.new.id(invoice_item.id).any?.should be_false
  end

  it "does not delete item if invoice finalized" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:paid)
    invoice_item = InvoiceItemFactory.create &.invoice_id(invoice.id)

    DeleteInvoiceItem.delete(
      InvoiceItemQuery.preload_invoice(invoice_item)
    ) do |operation, _|
      operation.deleted?.should be_false

      operation.invoice_id
        .should_not be_valid("operation.error.invoice_finalized")
    end

    InvoiceItemQuery.new.id(invoice_item.id).any?.should be_true
  end
end
