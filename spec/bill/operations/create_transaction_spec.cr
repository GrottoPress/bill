require "../../spec_helper"

describe Bill::CreateTransaction do
  it "creates credit transaction" do
    description = "New credit transaction"
    amount = 45
    type = TransactionType.new(:receipt)
    user = UserFactory.create
    receipt_id = 4

    CreateTransaction.create(
      params(
        user_id: user.id,
        credit: true,
        description: description,
        amount: amount,
        source: receipt_id,
        type: :receipt
      ),
      counter: 467
    ) do |_, transaction|
      transaction.should be_a(Transaction)

      # ameba:disable Lint/ShadowingOuterLocalVar
      transaction.try do |transaction|
        transaction.user_id.should eq(user.id)
        transaction.description.should eq(description)
        transaction.type.should eq(type)
        transaction.amount.should eq(-amount)
        transaction.reference.should eq("TRN467")
        transaction.receipt_id.should eq(receipt_id)
      end
    end
  end

  it "creates debit transaction" do
    description = "New debit transaction"
    amount = 43
    type = TransactionType.new(:invoice)
    user = UserFactory.create
    invoice_id = 4

    CreateTransaction.create(
      params(
        user_id: user.id,
        credit: false,
        description: description,
        amount: amount,
        source: invoice_id,
        type: :invoice
      ),
      counter: 467
    ) do |_, transaction|
      transaction.should be_a(Transaction)

      # ameba:disable Lint/ShadowingOuterLocalVar
      transaction.try do |transaction|
        transaction.user_id.should eq(user.id)
        transaction.description.should eq(description)
        transaction.type.should eq(type)
        transaction.amount.should eq(amount)
        transaction.reference.should eq("TRN467")
        transaction.invoice_id.should eq(invoice_id)
      end
    end
  end
end
