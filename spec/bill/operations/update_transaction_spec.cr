require "../../spec_helper"

describe Bill::UpdateTransaction do
  it "updates description only" do
    amount = 4
    new_description = "New transaction"
    type = TransactionType.new(:receipt)

    user = UserFactory.create
    user_2 = UserFactory.create &.email("me@you.her")

    transaction = TransactionFactory.create &.user_id(user.id)
      .amount(amount)
      .description("Awesome transaction")
      .type(type)

    UpdateTransaction.update(transaction, params(
      user_id: user_2.id,
      amount: 600,
      description: new_description,
      type: :invoice
    )) do |operation, updated_transaction|
      operation.saved?.should be_true

      updated_transaction.amount.should eq(amount)
      updated_transaction.description.should eq(new_description)
      updated_transaction.type.should eq(type)
      updated_transaction.user_id.should eq(user.id)
    end
  end
end
