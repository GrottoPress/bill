require "../../../../spec_helper"

describe Bill::Api::InvoicesStatus::Update do
  it "updates invoice status" do
    new_status = InvoiceStatus.new(:paid)

    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
    InvoiceItemFactory.create &.invoice_id(invoice.id)

    response = ApiClient.exec(
      Api::InvoicesStatus::Update.with(invoice_id: invoice.id),
      invoice: {status: new_status}
    )

    invoice.reload.status.should eq(new_status)

    response.should send_json(
      200,
      data: {invoice: {type: "InvoiceSerializer"}}
    )
  end
end
