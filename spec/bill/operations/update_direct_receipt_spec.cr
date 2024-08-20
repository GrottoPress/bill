require "../../spec_helper"

describe Bill::UpdateDirectReceipt do
  it "updates receipt transaction" do
    user = UserFactory.create

    transaction = TransactionFactory.create &.user_id(user.id)
      .amount(-20)
      .description("Awesome transaction")
      .status(:draft)
      .type(:receipt)

    new_user = UserFactory.create &.email("some@one.now")
    new_description = "Another transaction"
    new_amount = 45
    new_status = TransactionStatus.new(:open)

    UpdateDirectReceipt.update(transaction, params(
      user_id: new_user.id,
      amount: new_amount,
      credit: false,
      description: new_description,
      status: new_status,
      type: :invoice
    )) do |operation, updated_transaction|
      operation.saved?.should be_true

      updated_transaction.amount.should eq(-new_amount)
      updated_transaction.description.should eq(new_description)
      updated_transaction.status.should eq(new_status)
      updated_transaction.type.should eq(TransactionType.new(:receipt))
      updated_transaction.user_id.should eq(new_user.id)
    end
  end

  it "pays for a given invoice" do
    amount = 90
    user = UserFactory.create

    transaction = TransactionFactory.create &.user_id(user.id)
      .amount(-amount)
      .type(:receipt)

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

    UpdateDirectReceipt.update(transaction, params(
      invoice_id: invoice.id,
      status: :open,
    )) do |operation, _|
      operation.saved?.should be_true
    end

    invoice.reload.status.paid?.should be_true
    invoice_2.reload.status.open?.should be_true
  end
end
