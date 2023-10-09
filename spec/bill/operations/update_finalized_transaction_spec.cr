require "../../spec_helper"

describe Bill::UpdateFinalizedTransaction do
  it "updates finalized transaction" do
    new_description = "Another transaction"

    user = UserFactory.create

    transaction = TransactionFactory.create &.user_id(user.id)
      .status(:open)
      .amount(9)

    UpdateFinalizedTransaction.update(
      transaction,
      params(description: new_description, amount: 40)
    ) do |operation, updated_transaction|
      operation.saved?.should be_true
      updated_transaction.description.should eq(new_description)
      updated_transaction.amount.should eq(9)
    end
  end

  it "requires finalized transaction" do
    user = UserFactory.create
    transaction = TransactionFactory.create &.user_id(user.id).amount(9)

    UpdateFinalizedTransaction.update(
      transaction,
      params(description: "Another transaction")
    ) do |operation, _|
      operation.saved?.should be_false

      operation.status
        .should have_error("operation.error.transaction_not_finalized")
    end
  end
end
