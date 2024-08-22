require "../../../spec_helper"

describe Bill::DirectSalesReceipts::Edit do
  it "renders edit page" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)

    response = ApiClient.exec(DirectSalesReceipts::Edit.with(
      invoice_id: invoice.id
    ))

    response.body.should eq("DirectSalesReceipts::EditPage")
  end
end
