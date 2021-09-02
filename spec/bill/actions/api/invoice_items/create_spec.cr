require "../../../../spec_helper"

describe Bill::Api::InvoiceItems::Create do
  it "creates invoice item" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)

    response = ApiClient.exec(
      Api::InvoiceItems::Create.with(invoice_id: invoice.id), invoice_item: {
        description: "New invoice item",
        quantity: 2,
        price_mu: 3.33
      }
    )

    InvoiceItemQuery.new.any?.should be_true
    response.should send_json(200, data: {invoice: {type: "InvoiceSerializer"}})
  end
end
