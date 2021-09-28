require "../../../spec_helper"

private class SpecCreateInvoice < Invoice::SaveOperation
  permit_columns :user_id,
    :business_details,
    :description,
    :due_at,
    :status,
    :user_details

  include Bill::CreateInvoiceLineItems
  include Bill::CreateFinalizedInvoiceTransaction
end

private class SpecUpdateInvoice < Invoice::SaveOperation
  permit_columns :user_id,
    :business_details,
    :description,
    :due_at,
    :status,
    :user_details

  include Bill::CreateFinalizedInvoiceTransaction
end

describe Bill::CreateFinalizedInvoiceTransaction do
  it "creates transaction for new invoice" do
    user = UserFactory.create

    SpecCreateInvoice.create(
      params(
        user_id: user.id,
        business_details: "ACME Inc",
        description: "New invoice",
        due_at: 3.days.from_now.to_utc,
        status: :open,
        user_details: "Mary Smith"
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "2",
        "price" => "12"
      }]
    ) do |_, invoice|
      invoice.should be_a(Invoice)
    end

    TransactionQuery.new.user_id(user.id).any?.should be_true
  end

  it "creates transaction for existing invoice" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:draft)
    InvoiceItemFactory.create &.invoice_id(invoice.id)

    SpecUpdateInvoice.update(invoice, params(status: :open)) do |operation, _|
      operation.saved?.should be_true
    end

    TransactionQuery.new.user_id(user.id).any?.should be_true
  end

  it "does not create transaction for unfinalized invoices" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:draft)
    InvoiceItemFactory.create &.invoice_id(invoice.id)

    SpecUpdateInvoice.update(invoice, params(
      description: "Another invoice",
    )) do |operation, updated_invoice|
      operation.saved?.should be_true
    end

    TransactionQuery.new.user_id(user.id).any?.should be_false
  end

  it "does not create transaction for already finalized invoices" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
    InvoiceItemFactory.create &.invoice_id(invoice.id)

    SpecUpdateInvoice.update(invoice, params(
      description: "Another invoice"
    )) do |operation, updated_invoice|
      operation.saved?.should be_true
    end

    TransactionQuery.new.user_id(user.id).any?.should be_false
  end
end
