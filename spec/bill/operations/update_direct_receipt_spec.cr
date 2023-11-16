require "../../spec_helper"

private class SaveTransaction < Transaction::SaveOperation
  permit_columns :reference

  include Bill::UpdateDirectReceipt
end

describe Bill::UpdateDirectReceipt do
  it "updates receipt transaction" do
    user = UserFactory.create

    transaction = TransactionFactory.create &.user_id(user.id)
      .amount(-20)
      .description("Awesome transaction")
      .status(:draft)
      .type(:receipt)

    new_user = UserFactory.create &.email("some@one.now")
    new_description = "Another transaction"
    new_amount = 45
    new_status = TransactionStatus.new(:open)

    SaveTransaction.update(transaction, params(
      user_id: new_user.id,
      amount: new_amount,
      credit: false,
      description: new_description,
      status: new_status,
      type: :invoice
    )) do |operation, updated_transaction|
      operation.saved?.should be_true

      updated_transaction.amount.should eq(-new_amount)
      updated_transaction.description.should eq(new_description)
      updated_transaction.status.should eq(new_status)
      updated_transaction.type.should eq(TransactionType.new(:receipt))
      updated_transaction.user_id.should eq(new_user.id)
    end
  end
end
