require "../../../../spec_helper"

describe Bill::Api::Invoices::Show do
  it "show invoice" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)

    response = ApiClient.exec(Api::Invoices::Show.with(invoice_id: invoice.id))

    response.should send_json(
      200,
      data: {invoice: {type: "InvoiceSerializer"}}
    )
  end
end
