require "../../../../spec_helper"

describe Bill::Api::InvoiceItems::Show do
  it "shows invoice item" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    invoice_item = InvoiceItemFactory.create &.invoice_id(invoice.id)

    response = ApiClient.exec(Api::InvoiceItems::Show.with(
      invoice_item_id: invoice_item.id
    ))

    response.should send_json(
      200,
      data: {invoice_item: {type: "InvoiceItemSerializer"}}
    )
  end
end
