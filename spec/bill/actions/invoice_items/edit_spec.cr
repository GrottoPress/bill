require "../../../spec_helper"

describe Bill::InvoiceItems::Edit do
  it "renders edit page" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    invoice_item = InvoiceItemFactory.create &.invoice_id(invoice.id)

    response = ApiClient.exec(InvoiceItems::Edit.with(
      invoice_item_id: invoice_item.id
    ))

    response.body.should eq("InvoiceItems::EditPage")
  end
end
