require "../../../spec_helper"

private class SaveInvoice < Invoice::SaveOperation
  permit_columns :user_id,
    :business_details,
    :description,
    :due_at,
    :status,
    :user_details

  include Bill::EnsureDueAtGteCreatedAt
end

describe Bill::EnsureDueAtGteCreatedAt do
  it "ensures due date is never earlier than created date" do
    SaveInvoice.create(params(
      user_id: UserFactory.create.id,
      business_details: "ACME Inc",
      description: "New Invoice",
      due_at: 10.days.ago,
      status: :draft,
      user_details: "Mary Smith"
    )) do |_, invoice|
      invoice.should be_a(Invoice)

      invoice.try do |invoice|
        invoice.due_at.>=(invoice.created_at).should be_true
      end
    end
  end
end
