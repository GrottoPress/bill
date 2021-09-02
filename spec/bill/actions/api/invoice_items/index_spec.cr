require "../../../../spec_helper"

describe Bill::Api::InvoiceItems::Index do
  it "lists invoice items" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)

    response = ApiClient.exec(Api::InvoiceItems::Index.with(
      invoice_id: invoice.id
    ))

    response.should send_json(
      200,
      data: {invoice_items: Array(JSON::Any).new}
    )
  end
end
