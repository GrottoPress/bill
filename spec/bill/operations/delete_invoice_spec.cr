require "../../spec_helper"

describe Bill::DeleteInvoice do
  it "deletes invoice" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)

    DeleteInvoice.delete(invoice) do |operation, _|
      operation.deleted?.should be_true
    end

    # ameba:disable Performance/AnyInsteadOfEmpty
    InvoiceQuery.new.id(invoice.id).any?.should be_false
  end

  it "prevents deleting finalized invoice" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

    DeleteInvoice.delete(invoice) do |operation, _|
      operation.deleted?.should be_false

      operation.status.should have_error("operation.error.invoice_finalized")
    end
  end
end
