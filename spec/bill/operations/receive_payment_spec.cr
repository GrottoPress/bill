require "../../spec_helper"

describe Bill::ReceivePayment do
  it "creates new receipt" do
    description = "New receipt"
    amount = 45
    notes = "A note"
    status = ReceiptStatus.new(:open)

    user = UserFactory.create

    ReceivePayment.create(params(
      user_id: user.id,
      description: description,
      amount: amount,
      notes: notes,
      status: status
    )) do |_, receipt|
      receipt.should be_a(Receipt)

      receipt.try do |receipt|
        receipt.user_id.should eq(user.id)
        receipt.description.should eq(description)
        receipt.amount.should eq(amount)
        receipt.notes.should eq(notes)
        receipt.status.should eq(status)
      end
    end
  end
end
