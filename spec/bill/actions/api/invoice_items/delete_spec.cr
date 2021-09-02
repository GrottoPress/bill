require "../../../../spec_helper"

describe Bill::Api::InvoiceItems::Delete do
  it "deletes invoice item" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    invoice_item = InvoiceItemFactory.create &.invoice_id(invoice.id)

    response = ApiClient.exec(Api::InvoiceItems::Delete.with(
      invoice_item_id: invoice_item.id
    ))

    InvoiceItemQuery.new.id(invoice.id).any?.should be_false
    response.should send_json(200, data: {invoice: {type: "InvoiceSerializer"}})
  end
end
