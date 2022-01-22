require "../../../spec_helper"

private class SaveInvoice < Invoice::SaveOperation
  permit_columns :user_id,
    :business_details,
    :description,
    :due_at,
    :status,
    :user_details
end

private class SaveInvoiceItem < InvoiceItem::SaveOperation
  permit_columns :description, :quantity, :price

  include Bill::ValidateParentOperation
end

describe Bill::ValidateParentOperation do
  it "ensures parent is not finalized" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
    invoice_item = InvoiceItemFactory.create &.invoice_id(invoice.id)

    SaveInvoice.update(
      invoice,
      params(description: "Another invoice")
    ) do |operation, updated_invoice|
      operation.saved?.should be_true

      SaveInvoiceItem.update(
        invoice_item,
        params(description: "Another invoice item"),
        parent: operation
      ) do |operation, _|
        operation.saved?.should be_false

        operation.invoice_id
          .should have_error("operation.error.invoice_finalized")
      end
    end
  end

  it "ensures foreign key matches parent operation" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    invoice_2 = InvoiceFactory.create &.user_id(user.id)
    invoice_item = InvoiceItemFactory.create &.invoice_id(invoice_2.id)

    SaveInvoice.update(
      invoice,
      params(description: "Another invoice")
    ) do |operation, updated_invoice|
      operation.saved?.should be_true

      SaveInvoiceItem.update(
        invoice_item,
        params(description: "Another invoice item"),
        parent: operation
      ) do |operation, _|
        operation.saved?.should be_false

        operation.invoice_id
          .should have_error("operation.error.invoice_id_invalid")
      end
    end
  end
end
