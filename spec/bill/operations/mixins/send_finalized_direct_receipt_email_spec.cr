require "../../../spec_helper"

private class SaveTransaction < Transaction::SaveOperation
  permit_columns :user_id, :amount, :description, :reference, :status, :type

  include Bill::SendFinalizedDirectReceiptEmail

  skip_default_validations
end

describe Bill::SendFinalizedDirectReceiptEmail do
  it "sends email for new receipts" do
    SaveTransaction.create(params(
      user_id: UserFactory.create.id,
      description: "New receipt",
      amount: 65,
      type: :receipt,
      status: :open
    )) do |operation, transaction|
      transaction.should be_a(Transaction)

      # ameba:disable Lint/ShadowingOuterLocalVar
      transaction.try do |transaction|
        transaction = TransactionQuery.preload_user(transaction)
        NewDirectReceiptEmail.new(operation, transaction).should be_delivered
      end
    end
  end

  it "sends email for existing receipts" do
    user = UserFactory.create

    transaction = TransactionFactory.create &.user_id(user.id)
      .type(:receipt)
      .status(:draft)

    SaveTransaction.update(transaction, params(
      description: "Another receipt",
      status: :open
    )) do |operation, updated_transaction|
      operation.saved?.should be_true

      updated_transaction = TransactionQuery.preload_user(updated_transaction)

      NewDirectReceiptEmail.new(operation, updated_transaction)
        .should(be_delivered)
    end
  end

  it "does not send email if transaction type is not receipt" do
    SaveTransaction.create(params(
      user_id: UserFactory.create.id,
      description: "New credit note",
      amount: 65,
      type: :credit_note,
      status: :open
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

  it "does not send email for unfinalized receipts" do
    user = UserFactory.create
    transaction = TransactionFactory.create &.user_id(user.id).status(:draft)

    SaveTransaction.update(transaction, params(
      description: "Another receipt",
    )) do |operation, updated_transaction|
      operation.saved?.should be_true

      updated_transaction = TransactionQuery.preload_user(updated_transaction)

      NewDirectReceiptEmail.new(operation, updated_transaction)
        .should_not(be_delivered)
    end
  end

  it "does not send email for already finalized receipts" do
    user = UserFactory.create
    transaction = TransactionFactory.create &.user_id(user.id).status(:open)

    SaveTransaction.update(transaction, params(
      description: "Another receipt",
    )) do |operation, updated_transaction|
      operation.saved?.should be_true

      updated_transaction = TransactionQuery.preload_user(updated_transaction)

      NewDirectReceiptEmail.new(operation, updated_transaction)
        .should_not(be_delivered)
    end
  end
end
