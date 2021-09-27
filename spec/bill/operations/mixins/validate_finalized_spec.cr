require "../../../spec_helper"

private class SaveInvoice < Invoice::SaveOperation
  permit_columns :user_id,
    :business_details,
    :description,
    :due_at,
    :status,
    :user_details

  include Bill::ValidateFinalized
end

describe Bill::ValidateFinalized do
  it "prevents modifying unfinalized documents" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:draft)

    SaveInvoice.update(
      invoice,
      params(description: "Another invoice")
    ) do |operation, updated_invoice|
      operation.saved?.should be_false

      assert_invalid(operation.id, "not finalized")
    end
  end
end
