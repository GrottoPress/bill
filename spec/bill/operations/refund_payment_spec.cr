require "../../spec_helper"

describe Bill::RefundPayment do
  it "refunds payment" do
    description = "New refund"
    amount = 45
    meta_number = 6

    user = UserFactory.create

    RefundPayment.create(
      params(user_id: user.id, description: description, amount: amount),
      metadata: TransactionMetadata.from_json({number: meta_number}.to_json),
      receipt: nil
    ) do |_, transaction|
      transaction.should be_a(Transaction)

      transaction.try do |transaction|
        transaction.user_id.should eq(user.id)
        transaction.description.should eq(description)
        transaction.amount.should eq(amount)
        transaction.metadata.try(&.["number"]?).should eq(meta_number)
      end
    end
  end

  context "given a receipt" do
    it "refunds payment" do
      description = "New refund"
      amount = 45

      user = UserFactory.create

      receipt = ReceiptFactory.create &.user_id(user.id)
        .amount(amount)
        .status(:open)

      RefundPayment.create(
        params(description: description),
        receipt: receipt
      ) do |_, transaction|
        transaction.should be_a(Transaction)

        transaction.try do |transaction|
          transaction.user_id.should eq(user.id)
          transaction.description.should eq(description)
          transaction.amount.should eq(amount)
          transaction.metadata.try(&.receipt_id).should eq(receipt.id)
        end
      end
    end

    it "requires finalized receipt" do
      user = UserFactory.create
      receipt = ReceiptFactory.create &.user_id(user.id).status(:draft)

      RefundPayment.create(receipt: receipt) do |operation, _|
        operation.saved?.should be_false
        assert_invalid(operation.type, "operation.error.receipt_not_finalized")
      end
    end

    it "ensures amount is not higher than receipt amount" do
      user = UserFactory.create

      receipt = ReceiptFactory.create &.user_id(user.id)
        .amount(20)
        .status(:open)

      RefundPayment.create(
        params(amount: 55),
        receipt: receipt
      ) do |operation, _|
        operation.saved?.should be_false

        assert_invalid(
          operation.amount,
          "operation.error.refund_exceeds_receipt"
        )
      end
    end
  end
end
