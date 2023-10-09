require "../../spec_helper"

describe Bill::DeleteTransaction do
  it "deletes transaction" do
    user = UserFactory.create
    transaction = TransactionFactory.create &.user_id(user.id)

    DeleteTransaction.delete(transaction) do |operation, _|
      operation.deleted?.should be_true
    end

    # ameba:disable Performance/AnyInsteadOfEmpty
    TransactionQuery.new.id(transaction.id).any?.should be_false
  end

  it "prevents deleting finalized transaction" do
    user = UserFactory.create
    transaction = TransactionFactory.create &.user_id(user.id).status(:open)

    DeleteTransaction.delete(transaction) do |operation, _|
      operation.deleted?.should be_false

      operation.status
        .should(have_error "operation.error.transaction_finalized")
    end
  end
end
