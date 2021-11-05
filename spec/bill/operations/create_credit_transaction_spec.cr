require "../../spec_helper"

describe Bill::CreateCreditTransaction do
  it "creates credit transaction" do
    description = "New credit transaction"
    amount = 45
    type = TransactionType.new(:receipt)
    user = UserFactory.create
    receipt_id = 4

    CreateCreditTransaction.create(
      params(
        user_id: user.id,
        description: description,
        amount: amount,
        type: :receipt
      ),
      metadata: TransactionMetadata.from_json({receipt_id: receipt_id}.to_json)
    ) do |operation, transaction|
      transaction.should be_a(Transaction)

      transaction.try do |transaction|
        transaction.user_id.should eq(user.id)
        transaction.description.should eq(description)
        transaction.type.should eq(type)
        transaction.amount.should eq(-amount)

        transaction.metadata.should be_a(TransactionMetadata)

        transaction.metadata.try do |metadata|
          metadata.receipt_id.should eq(receipt_id)
        end
      end
    end
  end
end
