require "../../../../spec_helper"

describe Bill::Api::Invoices::Update do
  it "updates invoice" do
    new_description = "Another invoice"

    user = UserFactory.create

    invoice = InvoiceFactory.create &.user_id(user.id)
      .description("New invoice")
      .status(:draft)

    InvoiceItemFactory.create &.invoice_id(invoice.id)

    response = ApiClient.exec(
      Api::Invoices::Update.with(invoice_id: invoice.id),
      invoice: {description: new_description}
    )

    invoice.reload.description.should eq(new_description)

    response.should send_json(
      200,
      data: {invoice: {type: "InvoiceSerializer"}}
    )
  end
end
