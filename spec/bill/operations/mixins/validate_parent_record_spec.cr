require "../../../spec_helper"

private class SaveInvoiceItem < InvoiceItem::SaveOperation
  permit_columns :invoice_id, :description, :quantity, :price

  include Bill::ValidateParentRecord
end

describe Bill::ValidateParentRecord do
  it "ensures parent is not finalized" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
    invoice_item = InvoiceItemFactory.create &.invoice_id(invoice.id)

    SaveInvoiceItem.update(
      InvoiceItemQuery.preload_invoice(invoice_item),
      params(description: "Another invoice item")
    ) do |operation, _|
      operation.saved?.should be_false

      assert_invalid(operation.invoice_id, "finalized")
    end
  end
end
