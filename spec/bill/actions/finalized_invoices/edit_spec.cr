require "../../../spec_helper"

describe Bill::FinalizedInvoices::Edit do
  it "edits finalized invoice" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

    response = ApiClient.exec(FinalizedInvoices::Edit.with(
      invoice_id: invoice.id
    ))

    response.body.should eq("FinalizedInvoices::EditPage")
  end
end
