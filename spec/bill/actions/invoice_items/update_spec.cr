require "../../../spec_helper"

describe Bill::InvoiceItems::Update do
  it "updates invoice item" do
    new_description = "Another invoice item"

    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)

    invoice_item = InvoiceItemFactory.create &.invoice_id(invoice.id)
      .description("New invoice item")

    response = ApiClient.exec(
      InvoiceItems::Update.with(invoice_item_id: invoice_item.id),
      invoice_item: {description: new_description}
    )

    invoice_item.reload.description.should eq(new_description)
    response.status.should eq(HTTP::Status::FOUND)
  end
end
