require "../../../spec_helper"

private class SaveInvoice < Invoice::SaveOperation
  permit_columns :user_id,
    :business_details,
    :description,
    :due_at,
    :status,
    :user_details

  include Bill::SetFinalizedCreatedAt
end

describe Bill::SetFinalizedCreatedAt do
  it "updates date for newly finalized documents" do
    user = UserFactory.create

    invoice = InvoiceFactory.create &.user_id(user.id)
      .created_at(10.days.ago.to_utc)
      .status(:draft)

    SaveInvoice.update(
      invoice,
      params(status: :open)
    ) do |operation, updated_invoice|
      operation.saved?.should be_true
      updated_invoice.created_at.should be_close(Time.utc, 2.seconds)
    end
  end

  it "does not update date for already finalized documents" do
    created_at = 10.days.ago.to_utc.at_beginning_of_second

    user = UserFactory.create

    invoice = InvoiceFactory.create &.user_id(user.id)
      .created_at(created_at)
      .status(:open)

    SaveInvoice.update(
      invoice,
      params(description: "Another invoice")
    ) do |operation, updated_invoice|
      operation.saved?.should be_true
      updated_invoice.created_at.should eq(created_at)
    end
  end
end
