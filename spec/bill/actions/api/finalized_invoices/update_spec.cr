require "../../../../spec_helper"

describe Bill::Api::FinalizedInvoices::Update do
  it "updates invoice status" do
    new_description = "Another invoice"

    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
    InvoiceItemFactory.create &.invoice_id(invoice.id)

    response = ApiClient.exec(
      Api::FinalizedInvoices::Update.with(invoice_id: invoice.id),
      invoice: {description: new_description}
    )

    invoice.reload.description.should eq(new_description)

    response.should send_json(200, message: "action.invoice.update.success")
  end
end
