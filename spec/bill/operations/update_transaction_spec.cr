require "../../spec_helper"

describe Bill::UpdateTransaction do
  it "updates transaction" do
    user = UserFactory.create

    transaction = TransactionFactory.create &.user_id(user.id)
      .amount(-20)
      .description("Awesome transaction")
      .status(:draft)
      .type(:invoice)

    new_user = UserFactory.create &.email("some@one.now")
    new_description = "Another transaction"
    new_amount = 45
    new_status = TransactionStatus.new(:open)
    new_type = TransactionType.new(:receipt)

    UpdateTransaction.update(transaction, params(
      user_id: new_user.id,
      amount: new_amount,
      credit: false,
      description: new_description,
      status: new_status,
      type: new_type
    )) do |operation, updated_transaction|
      operation.saved?.should be_true

      updated_transaction.amount.should eq(new_amount)
      updated_transaction.description.should eq(new_description)
      updated_transaction.status.should eq(new_status)
      updated_transaction.type.should eq(new_type)
      updated_transaction.user_id.should eq(new_user.id)
    end
  end

  it "prevents modifying finalized transaction" do
    user = UserFactory.create
    transaction = TransactionFactory.create &.user_id(user.id).status(:open)

    UpdateTransaction.update(
      transaction,
      params(description: "Another transaction")
    ) do |operation, _|
      operation.saved?.should be_false

      operation.status
        .should(have_error "operation.error.transaction_finalized")
    end
  end
end
