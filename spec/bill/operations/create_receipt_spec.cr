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

    CreateReceipt.create(params(
      invoice_id: invoice.id,
      user_id: user.id,
      description: "New receipt",
      amount: amount,
      status: :open
    )) do |_, receipt|
      receipt.should be_a(Receipt)
    end

    invoice.reload.status.paid?.should be_true
    invoice_2.reload.status.open?.should be_true
  end
end
