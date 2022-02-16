require "../../../spec_helper"

describe Bill::Invoices::Delete do
  it "deletes invoice" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)

    response = ApiClient.exec(Invoices::Delete.with(invoice_id: invoice.id))

    # ameba:disable Performance/AnyInsteadOfEmpty
    InvoiceQuery.new.id(invoice.id).any?.should be_false

    response.status.should eq(HTTP::Status::FOUND)
  end
end
