require "../../../spec_helper"

describe Bill::InvoicesStatus::Edit do
  it "edits invoice status" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)

    response = ApiClient.exec(InvoicesStatus::Edit.with(invoice_id: invoice.id))

    response.body.should eq("InvoicesStatus::EditPage")
  end
end
