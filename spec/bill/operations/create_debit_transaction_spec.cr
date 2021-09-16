require "../../spec_helper"

describe Bill::CreateDebitTransaction do
  it "creates debit transaction" do
    description = "New debit transaction"
    amount = 43
    type = TransactionType.new(:invoice)
    user = UserFactory.create
    meta_id = 4

    CreateDebitTransaction.create(
      params(
        user_id: user.id,
        description: description,
        amount: amount,
        type: :invoice
      ),
      metadata: JSON.parse({id: meta_id}.to_json)
    ) do |operation, transaction|
      transaction.should be_a(Transaction)

      transaction.try do |transaction|
        transaction.user_id.should eq(user.id)
        transaction.description.should eq(description)
        transaction.type.should eq(type)
        transaction.amount.should eq(amount)

        transaction.metadata.should be_a(JSON::Any)

        transaction.metadata.try do |metadata|
          metadata["id"]?.should eq(meta_id)
        end
      end
    end
  end
end
