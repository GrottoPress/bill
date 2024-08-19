require "../../spec_helper"

describe Bill::CreateReceipt do
  it "creates new receipt" do
    description = "New receipt"
    amount = 45
    notes = "A note"
    status = ReceiptStatus.new(:open)

    user = UserFactory.create

    TransactionQuery.new.none?.should be_true

    CreateReceipt.create(
      params(
        user_id: user.id,
        description: description,
        amount: amount,
        notes: notes,
        status: status
      ),
      reference: "1401"
    ) do |_, receipt|
      receipt.should be_a(Receipt)

      receipt.try do |receipt| # ameba:disable Lint/ShadowingOuterLocalVar
        receipt.user_id.should eq(user.id)
        receipt.description.should eq(description)
        receipt.amount.should eq(amount)
        receipt.notes.should eq(notes)
        receipt.reference.should eq("1401")
        receipt.status.should eq(status)
      end
    end

    TransactionQuery.new
      .user_id(user.id)
      .type(:receipt)
      .is_finalized
      .none?
      .should(be_false)
  end
end
