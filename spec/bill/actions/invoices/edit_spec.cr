require "../../../spec_helper"

describe Bill::Invoices::Edit do
  it "edits invoice" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)

    response = ApiClient.exec(Invoices::Edit.with(invoice_id: invoice.id))

    response.body.should eq("Invoices::EditPage")
  end
end
