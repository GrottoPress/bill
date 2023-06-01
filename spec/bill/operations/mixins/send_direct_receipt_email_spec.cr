require "../../../spec_helper"

private class SaveTransaction < Transaction::SaveOperation
  permit_columns :user_id, :amount, :description, :reference, :type

  include Bill::SendDirectReceiptEmail
end

describe Bill::SendDirectReceiptEmail do
  it "sends email" do
    SaveTransaction.create(params(
      user_id: UserFactory.create.id,
      description: "New receipt",
      amount: 65,
      type: :receipt
    )) do |operation, transaction|
      transaction.should be_a(Transaction)

      # ameba:disable Lint/ShadowingOuterLocalVar
      transaction.try do |transaction|
        transaction = TransactionQuery.preload_user(transaction)
        NewDirectReceiptEmail.new(operation, transaction).should be_delivered
      end
    end
  end

  it "does not send email if transaction type is not receipt" do
    SaveTransaction.create(params(
      user_id: UserFactory.create.id,
      description: "New credit note",
      amount: 65,
      type: :credit_note
    )) do |operation, transaction|
      transaction.should be_a(Transaction)

      # ameba:disable Lint/ShadowingOuterLocalVar
      transaction.try do |transaction|
        transaction = TransactionQuery.preload_user(transaction)

        NewDirectReceiptEmail.new(operation, transaction)
          .should_not(be_delivered)
      end
    end
  end
end
