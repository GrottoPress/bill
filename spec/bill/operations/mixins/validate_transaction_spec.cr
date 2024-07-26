require "../../../spec_helper"

private class SaveTransaction < Transaction::SaveOperation
  permit_columns :user_id, :amount, :description, :reference, :status, :type

  include Bill::ValidateTransaction
end

describe Bill::ValidateTransaction do
  it "requires user id" do
    SaveTransaction.create(params(
      amount: 22,
      description: "New transaction",
      status: :open,
      type: :invoice
    )) do |operation, transaction|
      transaction.should be_nil

      operation.user_id.should have_error("operation.error.user_id_required")
    end
  end

  it "requires description" do
    SaveTransaction.create(params(
      user_id: UserFactory.create.id,
      amount: 33,
      status: :open,
      type: :invoice,
    )) do |operation, transaction|
      transaction.should be_nil

      operation.description
        .should have_error("operation.error.description_required")
    end
  end

  it "requires amount" do
    SaveTransaction.create(params(
      user_id: UserFactory.create.id,
      description: "New transaction",
      status: :open,
      type: :invoice,
    )) do |operation, transaction|
      transaction.should be_nil

      operation.amount.should have_error("operation.error.amount_required")
    end
  end

  it "requires status" do
    SaveTransaction.create(params(
      user_id: UserFactory.create.id,
      description: "New transaction",
      amount: 44,
      type: :invoice,
    )) do |operation, transaction|
      transaction.should be_nil

      operation.status.should have_error("operation.error.status_required")
    end
  end

  it "requires type" do
    SaveTransaction.create(params(
      user_id: UserFactory.create.id,
      description: "New transaction",
      amount: 44,
      status: :draft,
    )) do |operation, transaction|
      transaction.should be_nil

      operation.type.should have_error("operation.error.type_required")
    end
  end

  it "rejects zero amount" do
    SaveTransaction.create(params(
      user_id: UserFactory.create.id,
      description: "New transaction",
      amount: 0,
      status: :open,
      type: :invoice,
    )) do |operation, transaction|
      transaction.should be_nil

      operation.amount.should have_error("operation.error.amount_zero")
    end
  end

  it "requires existing user" do
    SaveTransaction.create(params(
      user_id: 2_i64,
      description: "New transaction",
      amount: 33,
      status: :open,
      type: :invoice,
    )) do |operation, transaction|
      transaction.should be_nil

      operation.user_id.should have_error("operation.error.user_not_found")
    end
  end

  it "ensures reference is unique" do
    reference = "123"

    user = UserFactory.create
    TransactionFactory.create &.user_id(user.id).reference(reference)

    SaveTransaction.create(params(
      user_id: user.id,
      description: "New transaction",
      amount: 33,
      reference: reference,
      status: :open,
      type: :invoice,
    )) do |operation, transaction|
      transaction.should be_nil

      operation.reference.should have_error("operation.error.reference_exists")
    end
  end

  it "rejects long description" do
    user = UserFactory.create

    SaveTransaction.create(params(
      user_id: user.id,
      description: "d" * 600,
      amount: 33,
      reference: "123",
      status: :open,
      type: :invoice,
    )) do |operation, transaction|
      transaction.should be_nil

      operation.description
        .should(have_error "operation.error.description_too_long")
    end
  end
end
