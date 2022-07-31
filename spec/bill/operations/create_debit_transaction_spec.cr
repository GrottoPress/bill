require "../../spec_helper"

describe Bill::CreateDebitTransaction do
  it "creates debit transaction" do
    description = "New debit transaction"
    amount = 43
    type = TransactionType.new(:invoice)
    user = UserFactory.create
    invoice_id = 4

    CreateDebitTransaction.create(
      params(
        user_id: user.id,
        description: description,
        amount: amount,
        type: :invoice
      ),
      id: 467,
      metadata: TransactionMetadata.from_json({invoice_id: invoice_id}.to_json)
    ) do |_, transaction|
      transaction.should be_a(Transaction)

      # ameba:disable Lint/ShadowingOuterLocalVar
      transaction.try do |transaction|
        transaction.user_id.should eq(user.id)
        transaction.description.should eq(description)
        transaction.type.should eq(type)
        transaction.amount.should eq(amount)
        transaction.reference.should eq("TRN467")

        transaction.metadata.should be_a(TransactionMetadata)

        transaction.metadata.try do |metadata|
          metadata.invoice_id.should eq(invoice_id)
        end
      end
    end
  end
end
