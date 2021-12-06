require "../../../../spec_helper"

describe Bill::Api::Invoices::Delete do
  it "deletes invoice" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)

    response = ApiClient.exec(
      Api::Invoices::Delete.with(invoice_id: invoice.id)
    )

    InvoiceQuery.new.id(invoice.id).any?.should be_false
    response.should send_json(200, message: "action.invoice.destroy.success")
  end
end
