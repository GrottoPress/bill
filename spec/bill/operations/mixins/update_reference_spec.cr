require "../../../spec_helper"

private class SaveInvoice < Invoice::SaveOperation
  include Bill::UpdateReference
end

describe Bill::UpdateReference do
  it "sets reference" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.counter(4).user_id(user.id).status(:open)

    SaveInvoice.update(invoice) do |operation, updated_invoice|
      operation.saved?.should be_true
      updated_invoice.reference.should eq("INV004")
    end
  end

  it "does not overwrite existing reference" do
    reference = "123"

    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).reference(reference)

    SaveInvoice.update(invoice) do |operation, updated_invoice|
      operation.saved?.should be_true
      updated_invoice.reference.should eq(reference)
    end
  end

  it "ensures reference is unique" do
    reference = "123"

    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).reference("K12")
    InvoiceFactory.create &.user_id(user.id).reference(reference)

    SaveInvoice.update(invoice, reference: reference) do |operation, _|
      operation.saved?.should be_false
      operation.reference.should have_error("operation.error.reference_exists")
    end
  end
end
