require "../../spec_helper"

describe Bill::DeleteInvoice do
  it "deletes invoice" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)

    DeleteInvoice.delete(invoice) do |operation, _|
      operation.deleted?.should be_true
    end

    InvoiceQuery.new.id(invoice.id).any?.should be_false
  end
end
