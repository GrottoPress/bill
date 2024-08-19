require "../../../spec_helper"

describe Bill::AutoMarkInvoicesAsPaid do
  it "marks invoices as paid" do
    user = UserFactory.create

    CreateReceipt.create(params(
      user_id: user.id,
      description: "New receipt",
      amount: 20,
      status: :open
    )) do |_, receipt|
      receipt.should be_a(Receipt)
    end

    invoice = CreateInvoice.create!(
      params(
        user_id: user.id,
        business_details: "ACME Inc",
        description: "Invoice 1",
        due_at: 1.day.from_now,
        status: :open,
        user_details: "Mary Smith"
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "1",
        "price" => "30"
      }]
    )

    invoice.reload.status.should eq(InvoiceStatus.new(:open))

    invoice_2 = CreateInvoice.create!(
      params(
        user_id: user.id,
        business_details: "ACME Inc",
        description: "Invoice 2",
        due_at: 2.days.from_now,
        status: :open,
        user_details: "Mary Smith"
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "1",
        "price" => "10"
      }]
    )

    invoice_2.reload.status.should eq(InvoiceStatus.new(:open))

    CreateCreditNote.create(
      params(
        invoice_id: invoice_2.id,
        description: "Cancel invoice 2",
        status: :open
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "1",
        "price" => "10"
      }]
    ) do |_, credit_note|
      credit_note.should be_a(CreditNote)
    end

    invoice.reload.status.should eq(InvoiceStatus.new(:open))
    invoice_2.reload.status.should eq(InvoiceStatus.new(:paid))

    CreateCreditNote.create(
      params(
        invoice_id: invoice.id,
        description: "Discount invoice 1",
        status: :open
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "1",
        "price" => "20"
      }]
    ) do |_, credit_note|
      credit_note.should be_a(CreditNote)
    end

    invoice.reload.status.should eq(InvoiceStatus.new(:paid))
    invoice_2.reload.status.should eq(InvoiceStatus.new(:paid))

    user_2 = UserFactory.create &.email("xyz@abc.def")

    invoice_3 = CreateInvoice.create!(
      params(
        user_id: user_2.id,
        business_details: "ACME Inc",
        description: "Invoice 3",
        due_at: 10.days.from_now,
        status: :open,
        user_details: "John Doe"
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "1",
        "price" => "10"
      }]
    )

    invoice_3.reload.status.should eq(InvoiceStatus.new(:open))

    invoice_4 = CreateInvoice.create!(
      params(
        user_id: user.id,
        business_details: "ACME Inc",
        description: "Invoice 4",
        due_at: 10.days.from_now,
        status: :open,
        user_details: "Mary Smith"
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "1",
        "price" => "10"
      }]
    )

    invoice_3.reload.status.should eq(InvoiceStatus.new(:open))
    invoice_4.reload.status.should eq(InvoiceStatus.new(:paid))

    invoice_5 = CreateInvoice.create!(
      params(
        user_id: user.id,
        business_details: "ACME Inc",
        description: "Invoice 5",
        due_at: Time.utc,
        status: :open,
        user_details: "Mary Smith"
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "1",
        "price" => "10"
      }]
    )

    invoice_4.reload.status.should eq(InvoiceStatus.new(:paid))
    invoice_5.reload.status.should eq(InvoiceStatus.new(:open))
  end
end
