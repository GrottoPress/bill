require "../../../spec_helper"

describe Bill::SalesReceipts::Edit do
  it "renders edit page" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)

    response = ApiClient.exec(SalesReceipts::Edit.with(invoice_id: invoice.id))

    response.body.should eq("SalesReceipts::EditPage")
  end
end
