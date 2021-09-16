require "../../../spec_helper"

private class SaveTransaction < Transaction::SaveOperation
  permit_columns :user_id, :amount, :description, :type

  include Bill::ValidateTransaction
end

describe Bill::ValidateTransaction do
  it "requires user id" do
    SaveTransaction.create(params(
      amount: 22,
      description: "New transaction",
      type: :invoice
    )) do |operation, transaction|
      transaction.should be_nil

      assert_invalid(operation.user_id, " required")
    end
  end

  it "requires description" do
    SaveTransaction.create(params(
      user_id: UserFactory.create.id,
      amount: 33,
      type: :invoice,
    )) do |operation, transaction|
      transaction.should be_nil

      assert_invalid(operation.description, " required")
    end
  end

  it "requires amount" do
    SaveTransaction.create(params(
      user_id: UserFactory.create.id,
      description: "New transaction",
      type: :invoice,
    )) do |operation, transaction|
      transaction.should be_nil

      assert_invalid(operation.amount, " required")
    end
  end

  it "rejects zero amount" do
    SaveTransaction.create(params(
      user_id: UserFactory.create.id,
      description: "New transaction",
      amount: 0,
      type: :invoice,
    )) do |operation, transaction|
      transaction.should be_nil

      assert_invalid(operation.amount, " zero")
    end
  end

  it "requires existing user" do
    SaveTransaction.create(params(
      user_id: 2_i64,
      description: "New transaction",
      amount: 33,
      type: :invoice,
    )) do |operation, transaction|
      transaction.should be_nil

      assert_invalid(operation.user_id, "not exist")
    end
  end

  it "prevents updating" do
    user = UserFactory.create
    transaction = TransactionFactory.create &.user_id(user.id)

    SaveTransaction.update(transaction, params(
      description: "New transaction",
      amount: 33,
      type: :invoice,
    )) do |operation, _|
      operation.saved?.should be_false

      assert_invalid(operation.id, "not allowed")
    end
  end
end
