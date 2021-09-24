require "../../../spec_helper"

private class SaveInvoice < Invoice::SaveOperation
  permit_columns :user_id,
    :business_details,
    :description,
    :due_at,
    :status,
    :user_details

  include Bill::RevertStatus
end

describe Bill::RevertStatus do
  it "reverts status update" do
    status = InvoiceStatus.new(:draft)

    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(status)

    UpdateInvoice.update(
      invoice,
      params(status: :open),
      line_items: Array(Hash(String, String)).new
    ) do |operation, updated_invoice|
      operation.saved?.should be_true
      updated_invoice.status.should eq(status)
    end
  end
end
