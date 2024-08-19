require "../../spec_helper"

private class SaveTransaction < Transaction::SaveOperation
  permit_columns :reference

  include Bill::CreateDirectReceipt
end

describe Bill::CreateDirectReceipt do
  it "creates receipt transaction" do
    description = "New receipt"
    amount = 45
    user = UserFactory.create

    SaveTransaction.create(params(
      user_id: user.id,
      description: description,
      amount: amount,
      type: :invoice,
      status: :open
    )) do |_, transaction|
      transaction.should be_a(Transaction)

      # ameba:disable Lint/ShadowingOuterLocalVar
      transaction.try do |transaction|
        transaction.user_id.should eq(user.id)
        transaction.description.should eq(description)
        transaction.type.should eq(TransactionType.new(:receipt))
        transaction.amount.should eq(-amount)
        transaction.status.should eq(TransactionStatus.new(:open))
      end
    end
  end
end
