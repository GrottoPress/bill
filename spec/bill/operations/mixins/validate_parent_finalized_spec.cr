require "../../../spec_helper"

private class SaveInvoiceItem < InvoiceItem::SaveOperation
  permit_columns :invoice_id, :description, :quantity, :price

  include Bill::ValidateParentFinalized
end

describe Bill::ValidateParentFinalized do
  it "ensures parent is finalized" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:draft)
    invoice_item = InvoiceItemFactory.create &.invoice_id(invoice.id)

    SaveInvoiceItem.update(
      InvoiceItemQuery.preload_invoice(invoice_item),
      params(description: "Another invoice item")
    ) do |operation, _|
      operation.saved?.should be_false

      assert_invalid(operation.invoice_id, "not finalized")
    end
  end
end