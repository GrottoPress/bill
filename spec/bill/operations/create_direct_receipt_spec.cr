require "../../spec_helper"

describe Bill::CreateDirectReceipt do
  it "creates receipt transaction" do
    description = "New receipt"
    amount = 45
    user = UserFactory.create

    CreateDirectReceipt.create(params(
      user_id: user.id,
      description: description,
      amount: amount,
      type: :invoice,
      status: :open
    )) do |_, transaction|
      transaction.should be_a(Transaction)

      # ameba:disable Lint/ShadowingOuterLocalVar
      transaction.try do |transaction|
        transaction.user_id.should eq(user.id)
        transaction.description.should eq(description)
        transaction.type.should eq(TransactionType.new(:receipt))
        transaction.amount.should eq(-amount)
        transaction.status.should eq(TransactionStatus.new(:open))
      end
    end
  end

  it "pays for a given invoice" do
    amount = 90
    user = UserFactory.create

    invoice = CreateInvoice.create!(
      params(
        user_id: user.id,
        description: "New invoice",
        due_at: 3.days.from_now,
        status: :open
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "1",
        "price" => "#{amount}"
      }]
    )

    invoice_2 = CreateInvoice.create!(
      params(
        user_id: user.id,
        description: "Another invoice",
        due_at: 2.days.from_now,
        status: :open
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "1",
        "price" => "#{amount}"
      }]
    )

    invoice.status.paid?.should be_false
    invoice_2.status.open?.should be_true

    CreateDirectReceipt.create(params(
      invoice_id: invoice.id,
      user_id: user.id,
      description: "New receipt",
      amount: amount,
      status: :open
    )) do |_, transaction|
      transaction.should be_a(Transaction)
    end

    invoice.reload.status.paid?.should be_true
    invoice_2.reload.status.open?.should be_true
  end
end
