require "../../../spec_helper"

private class SaveTransaction < Transaction::SaveOperation
  permit_columns :user_id, :amount, :description, :reference, :type

  skip_default_validations

  include Bill::EnsureCreatedAtNotPast
end

describe Bill::EnsureCreatedAtNotPast do
  it "ensures transaction is never in the past" do
    SaveTransaction.create(params(
      created_at: 10.days.ago,
      user_id: UserFactory.create.id,
      amount: 22,
      description: "New transaction",
      type: :invoice
    )) do |_, transaction|
      transaction.should be_a(Transaction)

      # ameba:disable Lint/ShadowingOuterLocalVar
      transaction.try do |transaction|
        transaction.created_at.should be_close(Time.utc, 2.seconds)
      end
    end
  end
end
