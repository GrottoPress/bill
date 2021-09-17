require "../../../spec_helper"

private class SaveInvoice < Invoice::SaveOperation
  permit_columns :user_id, :description, :due_at, :status

  include Bill::ValidateNotFinalized
end

describe Bill::ValidateNotFinalized do
  it "prevents modifying finalized documents" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

    SaveInvoice.update(
      invoice,
      params(description: "Another invoice")
    ) do |operation, updated_invoice|
      operation.saved?.should be_false

      assert_invalid(operation.id, "finalized")
    end
  end
end
