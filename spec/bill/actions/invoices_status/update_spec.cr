require "../../../spec_helper"

describe Bill::InvoicesStatus::Update do
  it "updates invoice status" do
    new_status = InvoiceStatus.new(:paid)

    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
    InvoiceItemFactory.create &.invoice_id(invoice.id)

    response = ApiClient.exec(
      InvoicesStatus::Update.with(invoice_id: invoice.id),
      invoice: {status: new_status}
    )

    invoice.reload.status.should eq(new_status)
    response.status.should eq(HTTP::Status::FOUND)
  end
end
