require "../../../spec_helper"

describe Bill::InvoiceItems::Show do
  it "shows invoice item" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    invoice_item = InvoiceItemFactory.create &.invoice_id(invoice.id)

    response = ApiClient.exec(InvoiceItems::Show.with(
      invoice_item_id: invoice_item.id
    ))

    response.body.should eq("InvoiceItems::ShowPage")
  end
end
