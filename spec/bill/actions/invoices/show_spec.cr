require "../../../spec_helper"

describe Bill::Invoices::Show do
  it "shows invoice" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)

    response = ApiClient.exec(Invoices::Show.with(invoice_id: invoice.id))

    response.body.should eq("Invoices::ShowPage")
  end
end
