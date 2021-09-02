require "../../../spec_helper"

describe Bill::InvoiceItems::Index do
  it "lists invoice items" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)

    response = ApiClient.exec(InvoiceItems::Index.with(
      invoice_id: invoice.id
    ))

    response.body.should eq("InvoiceItems::IndexPage")
  end
end
