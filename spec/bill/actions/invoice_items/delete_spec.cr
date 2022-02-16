require "../../../spec_helper"

describe Bill::InvoiceItems::Delete do
  it "deletes invoice item" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    invoice_item = InvoiceItemFactory.create &.invoice_id(invoice.id)

    response = ApiClient.exec(InvoiceItems::Delete.with(
      invoice_item_id: invoice_item.id
    ))

    # ameba:disable Performance/AnyInsteadOfEmpty
    InvoiceItemQuery.new.id(invoice.id).any?.should be_false

    response.status.should eq(HTTP::Status::FOUND)
  end
end
