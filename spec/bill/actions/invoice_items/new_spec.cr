require "../../../spec_helper"

describe Bill::InvoiceItems::New do
  it "renders new invoice item page" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)

    response = ApiClient.exec(InvoiceItems::New.with(invoice_id: invoice.id))

    response.body.should eq("InvoiceItems::NewPage")
  end
end
