require "../../../spec_helper"

describe Bill::ReceiveDirectInvoicePayment do
  it "requires open invoice" do
    amount = 90
    user = UserFactory.create

    invoice = CreateInvoice.create!(
      params(
        user_id: user.id,
        description: "New invoice",
        due_at: 3.days.from_now,
        status: :draft
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "1",
        "price" => "#{amount}"
      }]
    )

    CreateDirectReceipt.create(params(
      invoice_id: invoice.id,
      user_id: user.id,
      description: "New invoice",
      amount: amount,
      status: :open
    )) do |operation, receipt|
      receipt.should be_nil
      operation.invoice_id.should have_error("operation.error.invoice_not_open")
    end
  end

  it "ensures receipt amount equals invoice amount" do
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
        "price" => "90"
      }]
    )

    CreateDirectReceipt.create(params(
      invoice_id: invoice.id,
      user_id: user.id,
      description: "New invoice",
      amount: 100,
      status: :open
    )) do |operation, receipt|
      receipt.should be_nil

      operation.amount
        .should(have_error "operation.error.receipt_not_equal_invoice")
    end
  end
end
